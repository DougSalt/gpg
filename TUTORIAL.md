A small tutorial in how to use gpg from the command line to generate private/public key files, export them, encrypt and decrypt messages using those keys.

GOLDEN RULE for encrypting (signing and certification are separate issues):

PUBLIC KEY ENCRYPTS
PRIVATE KEY DECRYPTS

and never the twain shall meet. (except that they do - they are mathematically related)

A typical command line exchange of keys using `pgp` with generation of a private key will be:

1. `gpg --list-secret-keys (--keyid-format=long)` - lists all **your**
   *decryption* keys.
2. `gpg --list-keys` - lists all *encryption* keys.
3. `gpg --quick-gen-key "biggle <biggle@boggle.com>" [rsa4096 [encrypt [2023-10-01]]]`
    generates a private key (encryption key) and the corresponding public key

So the stuff in quotes is the *name* of the key. This can be any format but the
accepted standard seems to be "name <email address>". When specifying a key a
pattern match will be performed on this value.

[...] indicates optionality, and where usage is:

`rsa(dsa)(1024|2048|4096|8192...)` - this is the encryption type with the
length of the key - longer means more computational power needed, but orders of
magnitude more secure.

The next argument can be

+ `encrypt`(ion) - encryption key
+ `sign` - signing key (you get these from repositories to verify the code retrieved has not actually been tampered with).
+ `cert`(ification) - chain of trust stuff.
+ `auth`(entication) - no idea, and unsurprisingly with GnuPG I can find no
  documentationation on what this means, but were I to take a guess I would
  think that it can do any of the three previous tasks.

A date may be `never` or of the format YYYY-MM-DD - this is the expiry date of the key.

4. `gpg --export --armor > some-file.pub` - this will export *all* your private
   keys. If you want to select a particular encryption key then you must use
   `--local-user `some-string that matches the name section. This will produce
   a file which you may then email to people who wish to encrypt stuff using
   your key. This file is not sensitive. You can leave it anywhere. Theres is
   no way (currently) of rebuilding your private key from value. This key can
   only be used to encrypt stuff. The `--armor` or `-a` key

5. So the person who receives `some-file.pub` now need to import this key into
   their key ring and they do this using:

   `gpg --import some-file.pub`

   They now have the key ready for encrypting data that *only the person with
   the corresponding private key can decrypt*.

6. `gpg --encrypt some-file.txt` will cycle through your encryption keys
   matching the pattern you supply *on the first key it encounters in your key
   ring it matches*.  Or alternatively you can specify a particular recepient
   using `-r` or `--recepient` some user than matches `-a|--armor` if you want
   it in a sensible format  again matching the pattern you supply on the first
   key it encounters in your key ring it matches. The result of this will be in
   this case `some-file.txt.gpg`, i.e. it just appends `.gpg` to the original
   filename (you can override this should you choose).  This file is then
   emailed to the people whose public keys you have used to encrypt the
   message.

7. The last act is to decrypt the file, which is simply:

   `gpg --decrypt some-file.txt.gpg`

   This will pipe to the stdout the decrypted file along with some meta
   information about how the file was decrypted.

Keys can be removed by manipulation of the following options:

+ `gpg --delete-secret-key`
+ `gpg --delete-key`


