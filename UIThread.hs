module UIThread(UI, Context(Context), inUIThread, blocking, background) where

data UI a = UI (Context -> (a -> IO()) -> IO())

instance Monad UI where
  (>>=) task1 f = UI $ \c h ->
    runUI c $ runTask c task1 $ \val1 ->
      runUI c $ runTask c (f val1) h
    where runTask context (UI task) handler = task context handler

  return x = UI $ \c h -> h x

data Context = Context { runUI :: IO () -> IO(), runBackground :: IO () -> IO() }

blocking :: IO a -> UI a
blocking op = UI (\c h -> op >>= h)

background :: IO a -> UI a
background op = UI (\c h -> runBackground c $ op >>= h)

inUIThread :: Context -> UI () -> IO ()
inUIThread c (UI t) = runUI c $ t c $ \_ -> return ()
