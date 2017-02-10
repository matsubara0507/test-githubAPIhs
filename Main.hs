{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.String (fromString)
import Data.Text (pack)
import System.Environment (getArgs)
import GitHub.Data.Id
import GitHub.Endpoints.PullRequests (CreatePullRequest(..), PullRequest(..), createPullRequest, mergePullRequest)
import GitHub.Auth

main :: IO ()
main = do
  [token, user, repo, headb, baseb] <- getArgs
  let
    prTitle = mconcat ["Merge ", fromString baseb, " from ", fromString headb]
    prDetail = CreatePullRequest prTitle "" (fromString headb) (fromString baseb)
  pr <- createPullRequest (OAuth $ fromString token) (fromString user) (fromString repo) prDetail
  case pr of
    (Left err)   -> putStrLn $ "Error1: " ++ (show err)
    (Right stat) -> do
      mg <- mergePullRequest (OAuth $ fromString token)
              (fromString user) (fromString repo) (Id $ pullRequestNumber stat) Nothing
      case mg of
        (Left err)   -> putStrLn $ "Error2: " ++ (show err)
        (Right stat) -> putStrLn $ (show stat)
