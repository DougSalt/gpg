all: bin/gpg.jar

bin/AtEnd.class bin/Attach.class bin/ClearText.class  bin/ClearTextStorage$$.class  bin/ClearTextStorage.class  bin/Close.class  bin/Cmd.class  bin/Encrypt.class  bin/GPGConfiguration$$.class  bin/GPGConfiguration.class  bin/Open.class  bin/PassPhrase.class  bin/ReadLine.class : \
	src/main/scala/Encrypt.scala
	scalac -classpath lib/netlogo-6.0.4.jar -d bin src/main/scala/Encrypt.scala

bin/gpg.jar: \
	bin/AtEnd.class \
	bin/ClearText.class \
	bin/Attach.class \
	bin/ClearTextStorage$$.class \
	bin/ClearTextStorage.class \
	bin/Close.class \
	bin/Cmd.class \
	bin/Encrypt.class \
	bin/GPGConfiguration$$.class \
	bin/GPGConfiguration.class \
	bin/Open.class \
	bin/PassPhrase.class \
	bin/ReadLine.class
	jar -cvmf manifest.txt gpg.jar -C bin/ .
	mv gpg.jar examples/gpg

clean:
	rm -rf bin/*class
