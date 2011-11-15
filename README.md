UI Thread as Monad
==================

I got this digusted feeling when writing Android apps where you'll be
doing

~~~ .java
new Thread() {
  @Override
  public void run() {
    // ...
  }
}.start()
~~~

when putting something on the background and

~~~ .java 
runInUIThread(new Runnable() {
  public void run() {
  // ...
  }
});
~~~

At that point I'd been doing Haskell for some time and even defined some
of my own Monads. Well, I just wanted to see if I can create a Monad
that would make it easy to write UI code where your actions would be run
in a single thread and where you could easily do stuff on the background
too and return to the UI thread with the values returned from the
background tasks.. Well, I defined my own UI monad as in `UIThread.hs`..
With this monad, you could write code like

~~~ .haskell
twitterWiz :: UI ()
twitterWiz = do
  name <- alert "what's your twitter username?"
  tweets <- background $ queryTwitter name
  showTweets tweets

alert :: UI String
quearyTwitter :: IO [String]
showTweets :: [String] -> UI ()
~~~

The actions (on each line) would be un in the UI thread, each as
its own "event", without blocking the thread in between. Background
operations can be run using the `background` function that runs your IO
operations using a threadpool (or such) and then runs the next UI action
in the UI thread again. The `blocking` function can be used to run any
IO action in the UI thread. I figured the name should be shouting aloud
"I'll be blocking your UI thread if you get stupid".

Note that the UI Monad is fully functional: You can run UI actions using
the `inUiThread` function. The only catch here is that you have to
provide it with a `Context` which is practically a pair of functions:
one to submit a IO action to be run in the UI thread and other for
running an action on the background.

The simplest possible context would be

~~~ .haskell
blockingContext = Context id id
~~~

This would execute everything synchronously.

The only actually working example so far is in `ConsoleExample.hs`:

~~~ .haskell
main = do
  inUIThread blockingContext $ do
    blocking $ putStrLn "Enter your name : "
    name <- blocking $ getLine
    blocking $ putStrLn $ "Hello, " ++ name
~~~

It's really pathetic though: it's just performing IO actions in a
blocking way. Anyways it demonstrates that the UI Monad actually does something...
