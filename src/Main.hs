module Main where
import Gather
import System.Directory

main :: IO ()
main = do 
  mds <- inCurrentDirectory gather (extensions ".md")
  print mds
