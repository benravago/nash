#
set -x

/opt/jdk15/bin/java \
  -p $(find lib -name '*.jar' -printf %p:) \
  -m nashorn --anonymous-classes=false $*

