
JDK = "/opt/jdk15"
JAVA = "$(JDK)/bin/java"
JAVAC = "$(JDK)/bin/javac"
JAR = "$(JDK)/bin/jar"

version = "14.0"
tag = "jdk14-6c954123ee8d"

OW2ASM = "https://repo1.maven.org/maven2/org/ow2/asm"

define BINARY
	curl -sS $(OW2ASM)/$(1)/$(2)/$(1)-$(2).jar -o lib/$(1)-$(2).jar
endef

nash-14.jar: bin
	$(JAR) -c -e nashorn.tools.Shell -f $@ -C $< .

bin: bin/module-info.class bin/nashorn/internal/runtime/resources/version.properties 

bin/nashorn: ../ninja/bin ../codegen/bin lib/nasgen.jar
	mkdir -p bin
	$(JAVA) -cp $(shell find lib -name '*.jar' -printf %p:) \
		nashorn.build.tools.nasgen.Main ../ninja/bin nashorn.internal.objects ./bin
	cp -rup ../ninja/bin/* bin/
	cp -rup ../codegen/bin/* bin/

bin/module-info.class: bin/nashorn
	$(JAVAC) -d bin -cp ../ninja/bin:../codegen/bin src/engine/module-info.java

bin/nashorn/internal/runtime/resources/version.properties:
	mkdir -p $(@D)
	echo -e "version_short=$(version)\nversion_string=$(version)+$(tag)" > $@

../ninja/bin:
	$(eval URL := "$(shell dirname $$(git config --get remote.origin.url))")
	pushd .. ; git clone $(URL)/ninja ; cd codegen ; make ; popd

lib/nasgen.jar: lib
	rm -fr bin
	mkdir -p bin
	$(JAVAC) -d bin -sourcepath src -cp $(shell find lib -name 'asm-*.jar' -printf %p:) \
		src/nashorn/build/tools/nasgen/Main.java
	$(JAR) -c -e nashorn.build.tools.nasgen.Main -f $@ -C bin .
	rm -fr bin

lib:
	mkdir -p lib
	$(call BINARY,asm,8.0.1)
	$(call BINARY,asm-util,8.0.1)

clean:
	rm -fr bin lib *.jar

