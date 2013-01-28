{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE PackageImports #-}
{-# LANGUAGE EmptyDataDecls #-}

import qualified Database.MongoDB as M
import           Database.Persist.Store
import           Database.Persist.MongoDB
import           Database.Persist.TH
import           Data.Text (Text)
import qualified Data.Text as T
import qualified Data.ByteString.Char8 as B
import           MongoDB (entities)
import           Data.Monoid ((<>))
import "mtl"     Control.Monad.Error

instance Error Text where
  noMsg  = T.empty
  strMsg = T.pack

type Query = M.Action IO

runConn  = runMongoDBPool master
withConn = withMongoDBConn "jb55_ordering_test" "localhost" (M.PortNumber 27017) Nothing (fromIntegral 2)
run      = withConn . runConn

entities [persistUpperCase|
Nested
  one Int
  two Int
  deriving Show

Album
  nested [Nested]
  one Int
  two Int
  deriving Show
|]

main = do
  albums <- run $ (selectList [] [] :: Query [Entity Album])
  mapM_ print albums

