extensions [gpg csv]

to symmetric_decryption_no_passphrase
  gpg:home ""
  gpg:cmd ""
  let file gpg:open cryptogram
  while [ not (gpg:at-end? file) ] [
    output-show gpg:read-line file
  ]
  gpg:close file
end

to symmetric_decryption_with_passphrase
  (gpg:home)
  (gpg:cmd)
  let file (gpg:open cryptogram passphrase)
  while [ not (gpg:at-end? file) ] [
    output-show gpg:read-line file
  ]
  gpg:close file
end

to asymmetrically_decrypt_no_passphrase
  gpg:home homedir
  let file gpg:open cryptogram
  while [ not (gpg:at-end? file) ] [
    ifelse CSV [
      output-show csv:from-row gpg:read-line file
    ][
      output-show gpg:read-line file
    ]
  ]
  gpg:close file
end

to asymmetrically_decrypt_with_passphrase
  gpg:home homedir
  let file (gpg:open cryptogram passphrase)
  while [ not (gpg:at-end? file) ] [
    ifelse CSV [
      output-show csv:from-row gpg:read-line file
    ][
      output-show gpg:read-line file
    ]
  ]
  gpg:close file
end
@#$#@#$#@
GRAPHICS-WINDOW
783
273
816
307
-1
-1
25.0
1
10
1
1
1
0
1
1
1
0
0
0
0
0
0
1
ticks
30.0

BUTTON
19
91
296
125
Symmetrically decrypt (no passphrase)
Symmetric_decryption_no_passphrase\n; This should always fail
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
168
10
343
70
passphrase
NIL
1
0
String

OUTPUT
19
319
715
394
10

BUTTON
20
125
296
158
Symmetrally decrypt (with passphrase)
symmetric_decryption_with_passphrase\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
19
189
296
222
Asymmetrically decrypt (no passphrase)
asymmetrically_decrypt_no_passphrase
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
718
319
818
352
NIL
clear-output
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
19
10
157
55
cryptogram
cryptogram
"symmetric.gpg" "ppk.gpg" "csv.gpg"
0

TEXTBOX
301
91
808
151
Symmetric decryption with no password - this should always fail.\nSymmetric decryption will work with the password \"aPassword\"  and the cryptogram \"symmetric.gpg\".
11
0.0
1

BUTTON
19
221
296
254
Asymmetrically decrypt (with passphrase)
asymmetrically_decrypt_with_passphrase
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
301
186
819
280
The keyring in \"netlogo1\" subdirectory will work on \"ppk.gpg\" and has the passphrase \"TopSecret\".\n\nThe keyring in \"netlogo2\" subdirectory will work on the file \"ppk.gpg\" and \"csv.gpg\". This keyring has no passphrase. So this will work with or without a passphrase.
10
0.0
1

TEXTBOX
630
298
780
316
CLEAR TEXT
14
0.0
1

INPUTBOX
344
10
711
70
homedir
/home/doug/git/gpg/test/netlogo1
1
0
String

SWITCH
18
56
121
89
CSV
CSV
0
1
-1000

@#$#@#$#@
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
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
