
JDK = "/opt/jdk15"
JAVAC = "$(JDK)/bin/javac"
JAR = "$(JDK)/bin/jar"

OW2ASM = "https://repo1.maven.org/maven2/org/ow2/asm"

define BINARY
	curl -sS $(OW2ASM)/$(1)/$(2)/$(1)-$(2).jar -o lib/$(1)-$(2).jar
endef

lib/nasgen.jar: bin
	$(JAR) -c -e nashorn.build.tools.nasgen.Main -f $@ -C $< .

bin: lib
	mkdir -p bin
	$(JAVAC) -d bin -sourcepath src -cp $(shell find lib -name 'asm-*.jar' -printf %p:) src/nashorn/build/tools/nasgen/Main.java

lib:
	mkdir -p lib
	$(call BINARY,asm,8.0.1)
	$(call BINARY,asm-util,8.0.1)

clean:
	rm -fr bin lib

