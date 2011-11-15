module ConsoleExample where

import UIThread

blockingContext = Context id id

main = do
  inUIThread blockingContext $ do
    blocking $ putStrLn "Enter your name : "
    name <- blocking $ getLine
    blocking $ putStrLn $ "Hello, " ++ name

