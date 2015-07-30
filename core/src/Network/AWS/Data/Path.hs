{-# LANGUAGE DataKinds          #-}
{-# LANGUAGE DefaultSignatures  #-}
{-# LANGUAGE FlexibleInstances  #-}
{-# LANGUAGE GADTs              #-}
{-# LANGUAGE KindSignatures     #-}
{-# LANGUAGE LambdaCase         #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE StandaloneDeriving #-}

-- |
-- Module      : Network.AWS.Data.Path
-- Copyright   : (c) 2013-2015 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
module Network.AWS.Data.Path
    (
    -- * Path Types
      RawPath
    , EscapedPath

    -- * Constructing Paths
    , ToPath (..)
    , rawPath

    -- * Manipulating Paths
    , escapePath
    , collapsePath
    ) where

import qualified Data.ByteString.Char8       as BS8
import           Data.Monoid
import           Network.AWS.Data.ByteString
import           Network.AWS.Data.Text
import           Network.HTTP.Types.URI

class ToPath a where
    toPath :: a -> ByteString

instance ToPath ByteString where
    toPath = id

instance ToPath Text where
    toPath = toBS

rawPath :: ToPath a => a -> Path 'NoEncoding
rawPath = Raw . filter (not . BS8.null) . BS8.split sep . toPath

data Encoding = NoEncoding | Percent
    deriving (Eq, Show)

data Path :: Encoding -> * where
    Raw     :: [ByteString] -> Path 'NoEncoding
    Encoded :: [ByteString] -> Path 'Percent

deriving instance Show (Path a)
deriving instance Eq   (Path a)

type RawPath     = Path 'NoEncoding
type EscapedPath = Path 'Percent

instance Monoid RawPath where
    mempty                    = Raw []
    mappend (Raw xs) (Raw ys) = Raw (xs ++ ys)

instance ToByteString EscapedPath where
    toBS (Encoded []) = slash
    toBS (Encoded xs) = slash <> BS8.intercalate slash xs

escapePath :: Path a -> EscapedPath
escapePath (Raw     xs) = Encoded (map (urlEncode True) xs)
escapePath (Encoded xs) = Encoded xs

collapsePath :: Path a -> Path a
collapsePath = \case
    Raw     xs -> Raw     (go xs)
    Encoded xs -> Encoded (go xs)
  where
    go = reverse . f . reverse

    f :: [ByteString] -> [ByteString]
    f []            = []
    f (x:xs)
        | x == dot  = f xs
        | x == dots = drop 1 (f xs)
        | otherwise = x : f xs

    dot  = "."
    dots = ".."

slash :: ByteString
slash = BS8.singleton sep

sep :: Char
sep = '/'
