
JDK = "/opt/jdk15"
JAVA = "$(JDK)/bin/java"
JAVAC = "$(JDK)/bin/javac"
JAR = "$(JDK)/bin/jar"

version = "14.0"
tag = "jdk14-6c954123ee8d"

REPO = "https://repo1.maven.org/maven2"

define MAVEN
	curl -sS $(REPO)/$(1)/$(2)/$(3)/$(2)-$(3).jar -o $(4)/$(2)-$(3).jar
endef

nash.jar: bin
	$(JAR) -c -e nashorn.tools.Shell -f $@ -C $< .

bin: bin/module-info.class bin/nashorn/internal/runtime/resources/version.properties 

bin/nashorn: ../ninja/bin ../codegen/bin tools/nasgen.jar
	mkdir -p bin
	$(JAVA) -cp $(shell find tools -name '*.jar' -printf %p:) \
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

tools/nasgen.jar: tools
	rm -fr bin
	mkdir -p bin
	$(JAVAC) -d bin -sourcepath src -cp $(shell find $(@D) -name 'asm-*.jar' -printf %p:) \
		src/nashorn/build/tools/nasgen/Main.java
	$(JAR) -c -e nashorn.build.tools.nasgen.Main -f $@ -C bin .
	rm -fr bin

tools:
	mkdir -p $@
	$(call MAVEN,org/ow2/asm,asm,8.0.1,$@)
	$(call MAVEN,org/ow2/asm,asm-util,8.0.1,$@)

tests:
	mkdir -p $@
	$(call MAVEN,org/junit/jupiter,junit-jupiter-api,5.6.2,$@)
	$(call MAVEN,org/junit/jupiter,junit-jupiter-engine,5.6.2,$@)
	$(call MAVEN,org/junit/platform,junit-platform-commons,1.6.2,$@)
	$(call MAVEN,org/junit/platform,junit-platform-console,1.6.2,$@)
	$(call MAVEN,org/junit/platform,junit-platform-engine,1.6.2,$@)
	$(call MAVEN,org/junit/platform,junit-platform-launcher,1.6.2,$@)
	$(call MAVEN,org/opentest4j,opentest4j,1.2.0,$@)
	$(call MAVEN,org/apiguardian,apiguardian-api,1.1.0,$@)

tests/sputnik.jar: tests nash.jar
	rm -fr bin
	mkdir -p bin
	$(JAVAC) -d bin -sourcepath src -cp $(shell find $(@D) -name '*api*.jar' -printf %p:)nash.jar \
		src/sputnik/test/TestNashorn.java
	$(JAR) -c -f $@ -C bin .
	rm -fr bin

test: tests/sputnik.jar nash.jar
	$(JAVA) -Dtest.root=sputnik/tests \
	-cp $(shell find tests -name '*.jar' -printf %p:) \
	-p nash.jar --add-modules nashorn \
	org.junit.platform.console.ConsoleLauncher \
	--disable-banner --details=summary \
	-c sputnik.test.TestNashorn \
	> sputnik/out 2>sputnik/err


clean:
	rm -fr bin tools tests *.jar sputnik/{out,err}

