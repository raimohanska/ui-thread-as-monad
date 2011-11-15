UI Thread as Monad
==================

I got this digusted feeling when writing Android apps where you'll be
doing

~~~ .java
new Thread() {
  @Override
  public void run() {
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
