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
in the UI thread again.


