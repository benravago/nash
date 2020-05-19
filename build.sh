#
set -x

rm -fr lib
mkdir -p lib

cp codegen/codegen-*.jar lib
cp dynalink/dynalink-*.jar lib
cp engine/nashorn-*.jar lib

rm -fr bin

mkdir -p bin/nashorn/internal/runtime/resources/
cat << .. > bin/nashorn/internal/runtime/resources/version.properties
version_short=14.0
version_string=14.0+jdk14-6c954123ee8d
..

/opt/jdk15/bin/java \
  -cp nasgen/nasgen-14.jar:$(ls lib/codegen-*.jar) \
  nashorn.build.tools.nasgen.Main \
  engine/bin nashorn.internal.objects ./bin

/opt/jdk15/bin/jar \
  -u -f lib/nashorn-*.jar \
  -C bin .

