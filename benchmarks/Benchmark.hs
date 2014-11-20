import Control.Exception
import Criterion.Main
import Data.Word

import qualified System.Random as R
import qualified System.Random.MWC as MWC
import qualified System.Random.PCG as PCG
import qualified System.Random.PCG.Fast as F
import qualified System.Random.PCG.Single as S
import qualified System.Random.PCG.Unique as U
import qualified System.Random.Mersenne as M

benchIO :: String -> IO a -> Benchmark
benchIO s a = bench s (whnfIO a)

main :: IO ()
main = do
  mwc <- MWC.create
  pcg <- PCG.create
  pcgF <- F.create
  pcgS <- S.create
  pcgU <- U.create
  mtg <- M.newMTGen . Just =<< MWC.uniform mwc
  defaultMain
    [ bgroup "pcg"
      [ benchIO "Word32" (PCG.uniform pcg :: IO Word32)
      ]
    , bgroup "pcg-fast"
      [ benchIO "Word32" (F.uniform pcgF :: IO Word32)
      ]
    , bgroup "pcg-single"
      [ benchIO "Word32" (S.uniform pcgS :: IO Word32)
      ]
    , bgroup "pcg-unique"
      [ benchIO "Word32" (U.uniform pcgU :: IO Word32)
      ]
    , bgroup "mwc"
      [ benchIO "Word32" (MWC.uniform mwc :: IO Word32)
      -- , bench "Double" (uniform mwc :: IO Double)
      -- , bench "Int"    (uniform mwc :: IO Int)
      ]
    -- , bgroup "random"
    --   [ benchIO "Word32" (R.randomIO >>= evaluate :: IO Word32)
    --   , benchIO "Double" (R.randomIO >>= evaluate :: IO Double)
    --   , benchIO "Int"    (R.randomIO >>= evaluate :: IO Int)
    --   ]
    , bgroup "mersenne"
      [ benchIO "Word32" (M.random mtg :: IO Word32)
      -- , bench "Double" (M.random mtg :: IO Double)
      -- , bench "Int" (M.random mtg :: IO Int)
      ]
    ]