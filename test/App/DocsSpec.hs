module App.DocsSpec (
  spec,
) where

import App.Docs (fossaYmlDocUrl, newIssueUrl, userGuideUrl)
import App.Fossa.Container.Analyze (containerScanningDocUrl)
import Data.Foldable (for_)
import Data.Maybe (fromJust)
import Data.String.Conversion (toString)
import Data.Text (Text)
import Network.HTTP.Req (
  GET (GET),
  NoReqBody (NoReqBody),
  bsResponse,
  defaultHttpConfig,
  req,
  responseStatusCode,
  runReq,
  useHttpsURI,
 )
import Strategy.Cocoapods.Errors (refPodDocUrl)
import Strategy.Dart.Errors (refPubDocUrl)
import Strategy.Gradle.Errors (refGradleDocUrl)
import Strategy.Node.Errors (
  fossaNodeDocUrl,
  npmLockFileDocUrl,
  yarnLockfileDocUrl,
  yarnV2LockfileDocUrl,
 )
import Strategy.Python.Errors (commitPoetryLockToVCS)
import Strategy.Ruby.Errors (bundlerLockFileRationaleUrl, rubyFossaDocUrl)
import Strategy.Swift.Errors (
  swiftFossaDocUrl,
  swiftPackageResolvedRef,
  xcodeCoordinatePkgVersion,
 )
import Test.Hspec (Expectation, Spec, describe, it, shouldBe)
import Text.URI (mkURI)

shouldRespondToGETWithHttpCode :: Text -> Int -> Expectation
shouldRespondToGETWithHttpCode uri expected = do
  (url, _) <- fromJust . useHttpsURI <$> mkURI uri
  r <- runReq defaultHttpConfig $ req GET url NoReqBody bsResponse mempty
  responseStatusCode r `shouldBe` expected

urlsToCheck :: [Text]
urlsToCheck =
  [ userGuideUrl
  , newIssueUrl
  , fossaYmlDocUrl
  , bundlerLockFileRationaleUrl
  , rubyFossaDocUrl
  , refPubDocUrl
  , commitPoetryLockToVCS
  , npmLockFileDocUrl
  , yarnLockfileDocUrl
  , fossaNodeDocUrl
  , yarnV2LockfileDocUrl
  , swiftFossaDocUrl
  , swiftPackageResolvedRef
  , xcodeCoordinatePkgVersion
  , refPodDocUrl
  , refGradleDocUrl
  , containerScanningDocUrl
  ]

spec :: Spec
spec = do
  describe "Documentation links provided in application are reachable" $
    for_ urlsToCheck $ \url ->
      it (toString url <> " should be reachable") $
        url `shouldRespondToGETWithHttpCode` 200
