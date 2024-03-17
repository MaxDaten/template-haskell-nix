module Hello.HaskellSpec (spec) where

import Hello.Haskell
import Test.Hspec

spec :: Spec
spec = do
    describe "helloHaskell" $ do
        it "returns 'Hello Python'" $ do
            helloHaskell `shouldBe` "Hello, Haskell!"
