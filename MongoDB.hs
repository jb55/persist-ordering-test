{-# LANGUAGE TemplateHaskell #-}

module MongoDB (
  mongoSettings,
  entities
) where

import           Database.Persist.TH
import           Database.Persist.MongoDB (MongoBackend)
import           Language.Haskell.TH.Syntax (Type(..))
import qualified Database.MongoDB as M

mongoSettings :: MkPersistSettings
mongoSettings = mkPersistSettings $ ConT ''MongoBackend

entities = mkPersist mongoSettings
