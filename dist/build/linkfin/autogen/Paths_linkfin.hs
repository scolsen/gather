{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_linkfin (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/scottolsen/Library/Haskell/bin"
libdir     = "/Users/scottolsen/Library/Haskell/ghc-8.4.3-x86_64/lib/linkfin-0.1.0.0"
dynlibdir  = "/Users/scottolsen/Library/Haskell/ghc-8.4.3-x86_64/lib/x86_64-osx-ghc-8.4.3"
datadir    = "/Users/scottolsen/Library/Haskell/share/ghc-8.4.3-x86_64/linkfin-0.1.0.0"
libexecdir = "/Users/scottolsen/Library/Haskell/libexec/x86_64-osx-ghc-8.4.3/linkfin-0.1.0.0"
sysconfdir = "/Users/scottolsen/Library/Haskell/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "linkfin_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "linkfin_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "linkfin_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "linkfin_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "linkfin_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "linkfin_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
