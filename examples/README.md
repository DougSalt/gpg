
Used the following twice:

`gpg --homedir netlogo1 --gen-key`

To generate the first two keys, and

`gpg --homedir netlogo2 --gen-key`

to generate the 3rd with the follwoing details.

| User           | Email                  | Password        |  Homedir | 
|                |                        | (none if blank) |          |
|----------------|------------------------|----------------------------|
| NetLogo User 1 | <netlogo1@netlogo.com> | Secret          | netlogo1 |
| NetLogo User 2 | <netlogo2@netlogo.com> |                 | netlogo1 |
| NetLogo User 2 | <netlogo3@netlogo.com> | TopSecret       | netlogo2 |

This will generate the following files in netlogo1 and netlogo2:

+ pubring.gpg
+ secring.gpg
+ trustdb.gpg

We then moved the public keys around
```
gpg --homedir netlogo1 --export netlogo1@netlogo.com > pub1
gpg --homedir netlogo2 --import pub1

gpg --homedir netlogo1 --export netlogo2@netlogo.com > pub2
gpg --homedir netlogo2 --import pub2

gpg --homedir netlogo2 --export netlogo1@netlogo.com > pub3
gpg --homedir netlogo1 --import pub3
```

The following two files in this directory are the demonstation netlogo and gpg
cotnains the jar for the plugin.

demo.nlogo
gpg

The following is some random text encrypted with a symmetric key. The key being
the word "aPassword".

symmetric.gpg

This was encrypted using:

`gpg --symmetric --passphrase aPassword -o symmetric.gpg some_clear_text.txt`

The following is some random text encrypted for recipients:

ppk.ppg

for the following keys.

| Uid            | email                  |
|----------------|------------------------|
| NetLogo User 1 | <netlogo1@netlogo.com> |
| NetLogo User 2 | <netlogo2@netlogo.com> |
| NetLogo User 3 | <netlogo3@netlogo.com> |


