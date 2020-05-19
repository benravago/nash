#
set -x

rm -fr bin
mkdir -p bin

/opt/jdk15/bin/javac \
  -d bin -sourcepath src \
  -cp $(find lib -name '*.jar' -printf :%p) \
  $(find src -name '*.java')

rm -f nasgen-14.jar

/opt/jdk15/bin/jar \
  -c -f nasgen-14.jar \
  -e nashorn.build.tools.nasgen.Main \
  -C bin .

