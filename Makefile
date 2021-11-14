#

JDK="/opt/jdk17"

JAVAC="$(JDK)/bin/javac"
JAVA="$(JDK)/bin/java"
JAR="$(JDK)/bin/jar"

njs: lib/njs.jar

test: njs
	$(JAVA) -p lib/njs.jar -m njs hello.js

lib/njs.jar: src/njs src/asm lib/apt.jar
	rm -fr gen; mkdir -p gen
	find src/njs -name '*.properties' -exec cp --parents {} gen ';'
	find src/njs -name '*.java' > gen/files
	rm -fr bin; mkdir -p bin
	$(JAVAC) -d bin -sourcepath src/njs:src/asm @gen/files
	$(JAVA) -jar lib/apt.jar ./bin es.objects gen/src/njs
	$(JAR) -c -f lib/njs.jar -e nash.tools.Shell -C bin .
	$(JAR) -u -f lib/njs.jar -C gen/src/njs .

lib/apt.jar: src/apt src/asm
	rm -fr bin; mkdir -p bin
	$(JAVAC) -d bin -sourcepath src/apt:src/asm src/apt/nasgen/Main.java
	mkdir -p lib
	$(JAR) -c -f lib/apt.jar -e nasgen.Main -C bin .

clean:
	rm -fr bin gen lib

