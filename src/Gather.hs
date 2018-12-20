module Gather (gather,
               extensions,
               directories,
               fromCurrentDirectory,
               inCurrentDirectory) where
import System.Directory 
import Control.Monad
import Data.List

mapAbsolute :: [FilePath] -> IO [FilePath]
mapAbsolute = mapM makeAbsolute

directories :: [FilePath] -> IO [FilePath]
directories = filterM doesDirectoryExist

extensions :: String -> [FilePath] -> IO [FilePath]
extensions ext fp = filterM (\x -> return $ isSuffixOf ext x) fp

all :: [FilePath] -> IO [FilePath]
all fp =  return $ id fp

gather :: FilePath -> IO [FilePath]
gather x = do 
           this  <- makeAbsolute x 
           isDir <- doesDirectoryExist x
           if isDir 
           then do 
              content <- listDirectory x
              withCurrentDirectory this (mapAbsolute content)
           else return []

delve :: (FilePath -> IO [FilePath]) -> FilePath  -> ([FilePath] -> IO [FilePath]) -> IO [FilePath]
delve action fp f = do
                    first    <- action fp
                    result   <- go first []
                    f result
                  where go :: [FilePath] -> [FilePath] -> IO [FilePath]
                        go [] ys = return ys
                        go xs [] = do
                                   mapped <- mapM action xs
                                   go (concat  mapped) xs
                        go xs ys = do
                                   mapped <- mapM action xs
                                   go (concat mapped) (xs ++ ys)

fromCurrentDirectory :: (FilePath -> IO [FilePath]) -> ([FilePath] -> IO [FilePath]) -> IO [FilePath]
fromCurrentDirectory action qualifier = do
                                        cwd <- getCurrentDirectory
                                        delve action cwd qualifier

inCurrentDirectory :: (FilePath -> IO [FilePath]) -> ([FilePath] -> IO [FilePath]) -> IO [FilePath]
inCurrentDirectory action qualifier = do
                                    cwd    <- getCurrentDirectory 
                                    result <- action cwd 
                                    qualifier result
