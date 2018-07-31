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

