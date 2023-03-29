See [here](https://github.com/NetLogo/NetLogo-Libraries#netlogo-libraries) for iinstructions.

Fork the repository ihttps://github.com/NetLogo/NetLogo-Libraries in github.com. This is done by clicking the fork button in the right hand corner of the screen. Then clone this repository

```
git clone git@github.com:/DougSalt/NetLogo-Libraries
```

or if you have used this before then on the main page of github for that
project, switch to the 6.1 branch and pull to the state of the master.
You need to update your local version of NetLogo-libraries, locally:

```
git pull upstream 6.1
```

You need to update your local version of NetLogo-libraries, locally:

```
git pull upstream 6.1
```

Make a new branch

```
cd NetLogo-Libraries
git checkout -b gpg
# I don't think you need to do this line, but useful for pulling upstream.
git remote add upstream git@github.com:NetLogo/NetLogo-Libraries.git
```

copy the latest version of test/gpg/gpg.jar into the correct zip format
by using the command

```
cd ~/git/gpg/test/gpg
zip gpg-1.0.0.zip gpg.jar
cp gpg-1.0.0.zip ~/git/NetLogo-Libraries/extensions
```

where `1.0.0` is the version number

Add this file to `NetLogo-Libraries/extensions` directory.

Add the following to the `NetLogo-Libraries/libraries.conf`


{
    name: "Gnu Pretty Good Privacy"
    codeName: "gpg"
    shortDescription: "Gnu Pretty Good Privacy (GnuPG) Extension"
    longDescription: """Implements a NetLogo extension that utilises GnuPG privacy suite to decrypt data that is encoded symmetrically or asymmetrically.  This will allow for the secure storing of sensitive data in public repositories as these keys can be tailored to specific individuals or groups of individuals.  Additionally this allows the absolute destruction of publically available data providing the it can be proven that the keys for such data no longer exist.

Note GnuPG must be installed in the command path.
"""
    version: "1.0.0"
    homepage: "https://github.com/DougSalt/gpg.git"
    downloadURL: "https://raw.githubusercontent.com/NetLogo/NetLogo-Libraries/6.1/extensions/gpg-1.0.0.zip"
}

then

```
git add extensions/gpg.jar
git commit -a -m "Adding the GPG extension."
git push
```

The go up to https://github.com/DougSalt/NetLogo and generate a pull request back to the original repository.

