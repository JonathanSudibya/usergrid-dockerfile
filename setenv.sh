export JAVA_OPTS=${JAVA_OPTS}"-Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC -verbose:gc -Dlog4j.configuration=file:///${CATALINA_HOME}/lib/log4j.properties"