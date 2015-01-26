# Endless shape battle

The objective of the game is to score as many points as possible by shooting the shapes with the correct shape

Controls are:

* Z / GpButton1 - Shoot a circle
* X / GpButton2 - Shoot a square
* C / GpButton3 - Shoot a triangle
* <space> - Deploy a bomb if possible

And arrow keys for movement

Moving to the edge of the screen will result in a warp to the other side, this is aid player at higher level difficulty

# Building

Currently this build on OSX only

```
bundle install
bundle exec rake build_standalone
```

This willl output an .app file in the pkg/osx folder

# Credits / Thanks to

* Gosu authors - http://www.libgosu.org
* @BilBas - for ashton gem, and help resolving build issues
* Eric Skiff - http://www.ericskiff.com - for music

All other portions - Stephen Binns 2015
