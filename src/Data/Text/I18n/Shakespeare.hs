-- |
-- Module:      Data.Text.I18n.Shakespeare
-- Copyright:   (c) 2011-2016 Eugene Grigoriev
-- License:     BSD3
-- Maintainer:  Philip Cunningham <hello@filib.io>
-- Stability:   experimental
-- Portability: portable
--
-- This module is used to pull annotations out of Shakespeare templates.

module Data.Text.I18n.Shakespeare where

import Text.Hamlet
import Text.Hamlet.Parse
import Text.Shakespeare.Base

-- | Parse a document and pull out translation identifier bodies.
decode :: String -> String -> Either String [String]
decode keyword src =
  case parseDoc defaultHamletSettings src of
    Ok (_, docs)  -> Right $ findTranslations keyword docs
    Error message -> Left message
  where
    -- | Find strings prefixed by a given gettext identifier.
    findTranslations :: String -> [Doc] -> [String]
    findTranslations x xs =
      [body | DocContent (ContentVar (DerefBranch (DerefIdent (Ident i)) (DerefString body))) <- xs
            , i == x]