This is a small project to implement a pretty good privacy plugin for Netlogo.
An explanation of the structure and the files of this project resides in
MANIFEST.md (NOT manifest.txt, which is used to create the plugin jar).

Essentially this project has three parts.

1. A directory `paper` containing a paper describing the plugin and all the
   files used to develop and publish that paper (markdown and makefiles).
2. A directory `demo` containing a very simple NetLogo model to demonstrate the
   use of the plugin.
3. The remainder is the  code and supporting files used to develop the plugin.

The plugin is built with `sbt` - Scala Build Tool. This tool is invoked from
the command line and typing `help` at the command line which, unsurprisingly
shows help topics. However using `sbt` essentially boils down to an iteration
of the following:

1. <edit the file elsewhere>
2. `compile`
3. `package`
4. `release`
5. `netlogo`

`package` creates a jar, `release` copies the jar to the correct directory in
the demo Netlogo model, and `netlogo` invokes the Netlogo code.

`compile` and `package` are native `sbt` commands. I have provided `release`
and `netlogo` to allow rapid devlopment iteration, and there are underlying
versions of these to run in either a Windows or Linux environment.

The build file definition `build.sbt` and the command files used are all in
this current directory. 

# Upgrading.

1. Change the `manifest.txt` file and update the NetLogo versions
2. Copy the new Netlogo jar into lib and delete the old ones.
3. 
4. Launch sbt and compile,build, release and run netlogo
