# WARNING

As per usual Java is borked and broken. If you use above version 17 then this
will not work, and I have not had time to fix it yet. They have removed
functionality and it looks like SBT has not caught up yet. I hate this. It is
utterly 100% predictable, but 'tis life. At the moment you can run this on
version 17, but who knows for how long before something else in the developer
chain is broken.

To fix on OSX

```
brew tap homebrew/cask-versions
brew install --cask temurin17
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
```

Then run the remainder of this document.

# PURPOSE

This is a small project to implement a pretty good privacy plugin for Netlogo.
An explanation of the structure and the files of this project resides in
MANIFEST.md (NOT manifest.txt, which is used to create the plugin jar).

Essentially this project has three parts.

1. A directory `paper` containing a paper describing the plugin and all the
   files used to develop and publish that paper (markdown and makefiles).
2. A directory `test` containing a very simple NetLogo model to demonstrate the
   use of the plugin.
3. The remainder is the  code and supporting files used to develop the plugin.

# INSTALL

See the [installation instructions](INSTALL.md).

# MANIFEST

See the [manifest file](MANIFEST.md).

# BUILD

See the [build instructions](BUILD.md).

# UPGRADING

See the [upgrading instructions](UPGRADING.md).

# INSTRUCTIONS

<!-- Cut below this line and add into the Notes section of the demo Netlogo model, cbr.nlogo -->

## WHAT IS IT?

A gpgstration of a NetLogo plugin and  its design and implmentation. The plugin makes use of Gnu's Pretty Good Privacy software suite to encrypt arbitary data sources in Netlogo. This both secures the data to a reasonable degree and protects any sensitive data that might be in use for a publically available model.

## HOW IT WORKS

This uses Gnu's Pretty Good Privacy, and in particular the `gpg` command to decrypt encrypted data. The command `gpg` must be in the command path of the NetLogo user. This takes cryptograms encoded using `gpg` decodes them in-situ, whilst the NetLogo code is running. The decoding is lost upon closure of the NetLogo model, or explicity with the code using the corresponding command.

This plugin can make use of symmetric or asymmetric key encryption. The latter is the most powerful facility of `gpg`. Asymmetric encryption offers the ability for any individual to encrypt a message, but only specific individuals being able to decrypt the file, _without having passed any encryption keys_. This is achieved by encrypting the file with the public key of the recipient, so only the private key of the recipient can then unencrypt the cryptogram. This makes this form of encryption enormously secure, and hard to exploit, because the key is never exposed to other parties. This is the unique appeal of key asymmetry: the only people who can open the file must be in physical possession of the private key, and if a passphrase is used, then they must also know something as well.

Asymmetric key encryption tends to confuse people [@]. It may, however, be thought of in the following manner. Consider a chest which has two locks on it. The first lock is a deadlock and may only be locked permanently with a key, otherwise that lock is always open. If this lock is locked, then this triggers the latching of a second lock. The first key corresponds to the public key, the second to the private key. In this scenario, if a secret is locked in the box, by the public key, this causes the second lock to latch and lock. The box may only be opened if and only if we have both the public and private key. This is not quite how asymmetric encryption in `gpg` works, but is near enough to give a reasonable understanding of the principles and its implications. For instance using this box system we can pass a secret to a person who owns the private key, safe in the knowledge that once this box is locked only they can unlock it.  `gpg` is effectively just a method of leaving many copies of such boxes and many copies of such locking, public keys just lying around, just waiting to be used.


## HOW TO USE IT


The plugin has the following commands:

+ `gpg:cmd`
+ `gpg:home`
+ `gpg:open`
+ `gpg:read-line`
+ `gpg:at-end?`
+ `gpg:close`

Each of these are subsequently explained.

A note on terminology: a keyring is a directory in which private and public keys for asymmetric encryption are stored. A user can have multiple keyrings, but generally only has one.

### `gpg:cmd`

This sets the path of the `gpg` command if the `gpg` command is not in `$PATH` for \*nix system or `%PATH%` for Windows based systems. Its also allows the specification of additional parameters to `gpg`. This should not be needed. The only parameters that should require changing are the home directory containing the keyring. However, this can also be done using `gpg:home`. This multiple way of achieving the same end is due to OS sensitivity over paths.  `gpg:home` provides an operating system agnostic method of specifying the keyring directory. `gpg:cmd` also allows the `gpg` executable to be wrapped, or replaced with something else. This may appear to be a security weakness, and indeed it is, but the choice of calling the program externally to NetLogo implies that this can be done without `gpg:cmd`. That is, it is easy to replace the `gpg` binary with something nefarious. This also applies to any non-static library that NetLogo makes use of. So, although not air-tight security, this does offer "reasonable" security. The only way to obviate such a weakness would be to statically compile in such libraries and this has consequences for security and flexibility as elaborated earlier.

Some examples of the invocation of this command might be

```
gpg:cmd "/opt/gpg/bin/gpg"
```

or

```
gpg:cmd "gpg --homedir ~/some-directory"
```

Note, the state of execution string will persist, and not reset until the next invocation of `gpg:cmd`. The command can be cleared to default by using either

`gpg:cmd ""` or `(gpg:cmd)`


###  `gpg:home`

This sets the home directory relative to the directory in which the NetLogo model resides.

If this command is not used then `gpg` assumes the that its key ring resides in the sub-directory `.gnupg` of the standard home directory for that system.

Examples of the usage of this command might be 

```
gpg:home .keyrings
```

This would expect the keyrings to be found in a directory `.keyrings` immediately below the directory in which the NetLogo code for the model resides.

Note, the home-directory  will persist, and not reset until the next invocation
of `gpg:home`. The command can be cleared to default by using either

`gpg:home ""` or `(gpg:home)`

The home directory can also alternatively be set using: 

```
gpg:cmd "gpg --homedir ~/some-directory"
```

###  `gpg:open`

This attaches and decrypts a given cryptogram.

If `cryptogram_path` is the filename of the cryptogram and `cryptogram_id` will
be the variable holding the id of the attached and opened cryptogram, and in
addition the cryptogram has not been encrypted symmetrically, nor has does the
key that has encrypted it require a passphrase, then this command would be used
in the following manner. 

```
let cryptogram_id gpg:open cryptogram_path
```

If the cryptogram `cryptogram_path` has been symmetrically encoded, or the its
decoding key requires a passphrase then this can be specificed in the following
manner, where "some-passphrase" is the required phrase.

```
let cryptogram_id  (gpg:open 
    cryptogram_path "some-passphrase")
```


This will exception if the `cryptogram_path` does not exist, cannot be opened,
or requires a passphrase when none has been supplied..

###  `gpg:read-line`

Reads a line of clear text. from a previously opened cryptogram. The file must
have been successfully opened using `gpg:open`.

If `clear-text` is a previously declared NetLogo variable and `cryptogram_id`
is the variable holding the id of the attached and opened cryptogram, then this
command would be used in the following manner.

```
set clear-text gpg:read-line cryptogram_id
```

This will exception if the `cryptogram_id` does not represent a cryptogram that
is attached and opened.


###  `gpg:at-end?`

Tests whether there are additional lines of plain text available for
`gpg:read-line` to obtain. The file must have been successfully opened using
`gpg:open`.

If `cryptogram_id` is the variable holding the id of the attached and opened
cryptogram, then this command would be used in the following manner.

```
if gpg:at-end? cryptogram_id [
    ...
]
```

This will exception if the `cryptogram_id` does not represent a cryptogram that
is attached and opened.


###  `gpg:close`


Closes and detaches the cryptogram. The file must have been successfully opened
using `gpg:open`.  This means the data is no longer sitting in memory
encrypted.

If `cryptogram_id` is the variable holding the id of the attached and opened
cryptogram, then this command would be used in the following manner.

```
gpg:close cryptogram_id
```

This will exception if the `cryptogram_id` does not represent a cryptogram that
is attached and opened.

## THINGS TO NOTICE

In the demo code,there are 11 widgests.

These are 4 decryption buttons
An input field for the home directory. For this to work with the data generated below, then this input field must contain either:

+ `netlogo1`, or
+ `netlogo2`.

The keyring in `netlogo` has the passphrase 'TopSecret'. Notice if you use the correct
passphrase to decrypt something then gnupg will retain the catchphrase for `default-cache-ttl` (see below). This is normally half an hour.


## THINGS TO TRY

The directories in the directory of the model:

+ `netlogo1`;
+ `netlogo2`, and
+ `netlogo3`.

may be deleted and recreated with differing source data as an exercise for the reader to make sure they truly understand the concepts involved in symmetric and asymmetric encryption.

### The keys used in this demo

The following two files in this directory are the demonstration NetLogo and gpg
contains the jar for the plugin.

`gpg.nlogo`
`gpg`

The following is some random text encrypted with a symmetric key. The key being1
the word "aPassword".

symmetric.gpg

This was encrypted using:

`gpg --symmetric --passphrase aPassword -o symmetric.gpg some_clear_text.txt`

The asymmetrically encrypted cryptograms and keyrings used in this demo are set up as the follows. These encrypt the files

+ `ppk.txt`, and
+ `csv.txt`.

The first contains some recognizably coherent text the second contains a file in CSV format. The latter is included to show how `gpg` may be used in conjunction the 'csv` 
extension and this is demonstrated if the csv switch in the interface is to to true.
In the directory in which `gpg.nlogo` resides, then the keyrings used in this code are generated in the folowing manner.

In the directory wheret `gpg.nlogo` resides. To generate the first key with email <netlogo1@netlogo.com>.

```
mkdir netlogo1
gpg --homedir netlogo1 --gen-key
```

We add the passphrase 'TopSecret' when generating this key

To generate the second key with email <netlogo2@netlogo.com>.

```
mkdir netlogo2
gpg --homedir netlogo2 --gen-key
```

We use a blank passphrase on this user.


We now need a third user to actually do the encryption (we use no passphrase on this user)

```
mkdir netlogo3
gpg -homedir netlogo3 --gen-key
```

We use a blank passphrase on this user.

We now need to export and import the public keys for use when encrypting into this new user

```
gpg --homedir netlogo1 --export netlogo1@netlogo.com > netlogo3/netlogo1@netlogo.com.pub
gpg --homedir netlogo3 --import netlogo3/netlogo1@netlogo.com.pub
gpg --homedir netlogo2 --export netlogo2@netlogo.com > netlogo3/netlogo2@netlogo.com.pub
gpg --homedir netlogo3 --import netlogo3/netlogo2@netlogo.com.pub
```

Now to encrypt the files using netlogo3 user 

```
gpg --homedir netlogo3 --encrypt \
	--output ppk.gpg \
	--recipient netlogo2@netlogo.com \
	--recipient netlog1@netlogo.com ppk.txt

gpg --homedir netlogo3 --encrypt \
	--output csv.gpg \
	--recipient netlogo2@netlogo.com \
	--recipient netlog1@netlogo.com csv.txt
```

This will give the following public keys encrypted on the key ring
of netlogo3 in the directory `netlogo3`.

```
| User           | Email                  |  Homedir | 
|----------------|------------------------|----------|
| NetLogo User 1 | <netlogo1@netlogo.com> | netlogo1 |
| NetLogo User 2 | <netlog23@netlogo.com> | netlogo2 |
```

This will generate several files in `netlogo1`, `netlogo2` and `netlogo3`:

for the following keys.

```
| Uid            | email                  |
|----------------|------------------------|
| NetLogo User 1 | <netlogo1@netlogo.com> |
| NetLogo User 2 | <netlogo2@netlogo.com> |
| NetLogo User 3 | <netlogo3@netlogo.com> |
```

## EXTENDING THE MODEL

`gnupg` could be replaced by any other encryption suite. The process of decryption is 
effectively the same. This facility is explictly provide for in the command `gpp:cmd`.

## NETLOGO FEATURES

Not strictly a NetLogo feature, but it should be noted that `gnupgp` caches credentials.
What this in effect means that if you have already entered a passphrase to unlock a private key for asymmetric encryption, then `gnuppg` will retain that passphrase for the number of seconds defined for caching. This means that the passprhase will effective be useless during this period of cache, if the corrrect passphrase has been used in the `ttl period`. This can be confusing. 

The time this is set for is present in

`default-cache-ttl`

This may be access using the following command:

`
gpg-conf --list-options gpg-agent | grep 'default-cache-ttl'
`

and set editing:

`~/.gnupg/gpg-agent.conf`

and adding the line:

`max-cache-ttl 3600`

If it is for an hour.

## RELATED MODELS

Hopefully some models will eventually use this to proect data. It should be noted that once the keys are lost, or destroyed

## CREDITS AND REFERENCES

doug.salt@hutton.ac.uk
