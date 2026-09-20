{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
#if __GLASGOW_HASKELL__ >= 810
{-# OPTIONS_GHC -Wno-prepositive-qualified-module #-}
#endif
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_bend_ucm (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
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

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath




bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/private/tmp/unison-84b95a623711b57b9ff7163f124b214d626b81e4/.stack-work/install/aarch64-osx/a4be68debb28d83212c9305d5ac004a301d934a599926413e8ebb5918ab75462/9.10.3/bin"
libdir     = "/private/tmp/unison-84b95a623711b57b9ff7163f124b214d626b81e4/.stack-work/install/aarch64-osx/a4be68debb28d83212c9305d5ac004a301d934a599926413e8ebb5918ab75462/9.10.3/lib/aarch64-osx-ghc-9.10.3-fe9c/bend-ucm-0.1.0.0-HJJibfEJl7qHkY5iecIBcb"
dynlibdir  = "/private/tmp/unison-84b95a623711b57b9ff7163f124b214d626b81e4/.stack-work/install/aarch64-osx/a4be68debb28d83212c9305d5ac004a301d934a599926413e8ebb5918ab75462/9.10.3/lib/aarch64-osx-ghc-9.10.3-fe9c"
datadir    = "/private/tmp/unison-84b95a623711b57b9ff7163f124b214d626b81e4/.stack-work/install/aarch64-osx/a4be68debb28d83212c9305d5ac004a301d934a599926413e8ebb5918ab75462/9.10.3/share/aarch64-osx-ghc-9.10.3-fe9c/bend-ucm-0.1.0.0"
libexecdir = "/private/tmp/unison-84b95a623711b57b9ff7163f124b214d626b81e4/.stack-work/install/aarch64-osx/a4be68debb28d83212c9305d5ac004a301d934a599926413e8ebb5918ab75462/9.10.3/libexec/aarch64-osx-ghc-9.10.3-fe9c/bend-ucm-0.1.0.0"
sysconfdir = "/private/tmp/unison-84b95a623711b57b9ff7163f124b214d626b81e4/.stack-work/install/aarch64-osx/a4be68debb28d83212c9305d5ac004a301d934a599926413e8ebb5918ab75462/9.10.3/etc"

getBinDir     = catchIO (getEnv "bend_ucm_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "bend_ucm_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "bend_ucm_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "bend_ucm_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "bend_ucm_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "bend_ucm_sysconfdir") (\_ -> return sysconfdir)



joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
