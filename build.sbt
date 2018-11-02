lazy val gpg = (project in file("."))
  .settings(
    name := "gpg",
    scalaVersion := "2.12.6",
    packageOptions in (Compile, packageBin) +=  {
      val file = new java.io.File("manifest.txt")
      val manifest = Using.fileInputStream(file)( in => new java.util.jar.Manifest(in) )
      Package.JarManifest( manifest )
    }
  )

lazy val release = taskKey[Unit]("Execute release script")
release:= {
    val os = {"uname" !!}.stripLineEnd
    println("OS = " + os)
    if ( os == "Linux" ) {
      "./release.sh" !
    } else {
      "./release.bat" !
    }
}

lazy val netlogo = taskKey[Unit]("Execute nlogo")
netlogo := {
   val os = {"uname" !!}.stripLineEnd
    println("OS = " + os)
    if ( os == "Linux" ) {
      "./run.sh" !
    } else {
      "./run.bat" !
    }
}

