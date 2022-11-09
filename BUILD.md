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


