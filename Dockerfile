FROM jeanblanchard/tomcat:8

MAINTAINER Jonathan Sudibya <jonathans121@gmail.com>

ENV USERGRID_HOME /opt/usergrid

RUN apk add --update curl &&\
	curl -LO http://apache.repo.unpas.ac.id/usergrid/usergrid-2/v2.1.0/apache-usergrid-2.1.0-binary.tar.gz &&\
	curl -LO https://raw.githubusercontent.com/apache/usergrid/release-2.1.1/stack/config/src/main/resources/usergrid-default.properties &&\
	mkdir -p ${USERGRID_HOME} &&\
	tar -xzf apache-usergrid-2.1.0-binary.tar.gz -C ${USERGRID_HOME} &&\
	rm -rf ${CATALINA_HOME}/webapps/* &&\
	cp ${USERGRID_HOME}/apache-usergrid-2.1.0/stack/ROOT.war ${CATALINA_HOME}/webapps &&\
	cp usergrid-default.properties ${CATALINA_HOME}/lib/usergrid-deployment.properties &&\
	rm -rf ${USERGRID_HOME}/* apache-usergrid-2.1.0-binary.tar.gz

CMD bin/sh ${CATALINA_HOME}/bin/run.sh

ADD ./log4j.properties ${CATALINA_HOME}/lib/

ADD ./setenv.sh ${CATALINA_HOME}/bin/

ADD ./run.sh ${CATALINA_HOME}/bin/
