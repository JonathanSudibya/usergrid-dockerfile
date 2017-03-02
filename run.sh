#!/bin/bash

#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# this script is invoked after starting up the docker container.
# it allows for configuration at run time instead of baking all
# configuration settings into the container. you can set all configurable
# options using environment variables.
#
# overwrite any of the following default values at run-time like this:
#  docker run --env <key>=<value>

if [ -z "${CASSANDRA_CLUSTER_NAME}" ]; then
  CASSANDRA_CLUSTER_NAME='usergrid'
fi
if [ -z "${USERGRID_CLUSTER_NAME}" ]; then
  USERGRID_CLUSTER_NAME='usergrid'
fi
if [ -z "${ADMIN_USER}" ]; then
  ADMIN_USER=admin
fi
if [ -z "${ADMIN_PASS}" ]; then
  ADMIN_PASS=admin
fi
if [ -z "${ADMIN_MAIL}" ]; then
  ADMIN_MAIL=admin@example.com
fi
if [ -z "${ORG_NAME}" ]; then
  ORG_NAME=org
fi
if [ -z "${APP_NAME}" ]; then
  APP_NAME=app
fi
if [ -z "${TOMCAT_RAM}" ]; then
  TOMCAT_RAM=512m
fi
if [ -z "${VERSION}" ]; then
  VERSION=2.1
fi
if [ -z "${CASSANDRA_VERSION}" ]; then
  CASSANDRA_VERSION=2.1
fi
if [ -z "${CASSANDRA_URLS}" ]; then
  CASSANDRA_URLS=127.0.0.1:9160
fi
if [ -z "${ELASTICSEARCH_HOSTS}" ]; then
  ELASTICSEARCH_HOSTS=127.0.0.1
fi
if [ -z "${ELASTICSEARCH_PORT}" ]; then
  ELASTICSEARCH_PORT=9300
fi

echo "+++ usergrid configuration:  CASSANDRA_CLUSTER_NAME=${CASSANDRA_CLUSTER_NAME}  USERGRID_CLUSTER_NAME=${USERGRID_CLUSTER_NAME}  ADMIN_USER=${ADMIN_USER}  ORG_NAME=${ORG_NAME}  APP_NAME=${APP_NAME}  TOMCAT_RAM=${TOMCAT_RAM}"


# start usergrid
# ==============

echo "+++ configure usergrid"

# USERGRID_PROPERTIES_FILE=/usr/share/tomcat7/lib/usergrid-deployment.properties
USERGRID_PROPERTIES_FILE=${CATALINA_HOME}/lib/usergrid-deployment.properties

sed -i "s/cassandra.url=.*/cassandra.url=$CASSANDRA_URLS/g" $USERGRID_PROPERTIES_FILE
sed -i "s/cassandra.cluster=.*/cassandra.cluster=$CASSANDRA_CLUSTER_NAME/g" $USERGRID_PROPERTIES_FILE
sed -i "s/#usergrid.cluster_name=.*/usergrid.cluster_name=$USERGRID_CLUSTER_NAME/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.version.build=.*/usergrid.version.build=$VERSION/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.sysadmin.login.name=.*/usergrid.sysadmin.login.name=$ADMIN_USER/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.sysadmin.login.email=.*/usergrid.sysadmin.login.email=$ADMIN_MAIL/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.sysadmin.login.password=.*t/usergrid.sysadmin.login.password=$ADMIN_PASS/g" $USERGRID_PROPERTIES_FILE
sed -i "s/^\(usergrid\.test\-account\)\(.*\)/#\1\2/g" $USERGRID_PROPERTIES_FILE
sed -i "s/#?elasticsearch.hosts=.*/elasticsearch.hosts=${ELASTICSEARCH_HOSTS}/g" $USERGRID_PROPERTIES_FILE
sed -i "s/#?elasticsearch.port=.*/elasticsearch.port=${ELASTICSEARCH_PORT}/g" $USERGRID_PROPERTIES_FILE
sed -i "s/#?usergrid.use.default.queue=false/usergrid.use.default.queue=true/g" $USERGRID_PROPERTIES_FILE
sed -i "s/#?elasticsearch.queue_impl=LOCAL/elasticsearch.queue_impl=LOCAL/g" $USERGRID_PROPERTIES_FILE
sed -i "s/#?cassandra.version=.*/cassandra.version=$CASSANDRA_VERSION/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.sysadmin.email=.*/usergrid.sysadmin.email=$ADMIN_MAIL/g" $USERGRID_PROPERTIES_FILE
sed -i "s/usergrid.admin.sysadmin.email=.*/usergrid.admin.sysadmin.email=$ADMIN_MAIL/g" $USERGRID_PROPERTIES_FILE

if [ -n "${TRANSPORT_PROTOCOL}" ]; then
  sed -i "s/mail.transport.protocol=.*/mail.transport.protocol=$TRANSPORT_PROTOCOL/g" $USERGRID_PROPERTIES_FILE
fi
if [ -n "${SMTPS_HOST}" ]; then
  sed -i "s/mail.smtps.host=.*/mail.smtps.host=$SMTPS_HOST/g" $USERGRID_PROPERTIES_FILE
fi
if [ -n "${SMTPS_PORT}" ]; then
  sed -i "s/mail.smtps.port=.*/mail.smtps.port=$SMTPS_PORT/g" $USERGRID_PROPERTIES_FILE
fi
if [ -n "${SMTPS_AUTH}" ]; then
  sed -i "s/mail.smtps.auth=.*/mail.smtps.auth=$SMTPS_AUTH/g" $USERGRID_PROPERTIES_FILE
fi
if [ -n "${SMTPS_USERNAME}" ]; then
  sed -i "s/mail.smtps.username=.*/mail.smtps.username=$SMTPS_USERNAME/g" $USERGRID_PROPERTIES_FILE
fi
if [ -n "${SMTPS_PASSWORD}" ]; then
  sed -i "s/mail.smtps.pasword=.*/mail.smtps.host=$SMTPS_PASSWORD/g" $USERGRID_PROPERTIES_FILE
fi
if [ -n "${MANAGEMENT_MAILER}" ]; then
  sed -i "s/usergrid.management.mailer=.*/usergrid.management.mailer=$MANAGEMENT_MAILER/g" $USERGRID_PROPERTIES_FILE
fi
if [ -n "${REDIRECT_ROOT}" ]; then
  sed -i "s/usergrid.redirect.root=.*/usergrid.redirect.root=$REDIRECT_ROOT/g" $USERGRID_PROPERTIES_FILE
fi
if [ -n "${USER_COMFIRMATION}" ]; then
  sed -i "s/usergrid.management.admin_users_require_confirmation=.*/usergrid.management.admin_users_require_confirmation=$USER_COMFIRMATION/g" $USERGRID_PROPERTIES_FILE
fi
if [ -n "${URL_BASE}" ]; then
  sed -i "s/usergrid.api.url.base=.*/usergrid.api.url.base=$URL_BASE/g" $USERGRID_PROPERTIES_FILE
fi

# update tomcat's java options
sed -i "s/\(.*\)-Xmx128m\(.*\)/\1-Xmx${TOMCAT_RAM} -Xms${TOMCAT_RAM}\2/g" ${CATALINA_HOME}/bin/setenv.sh

echo "+++ start usergrid"
${CATALINA_HOME}/bin/catalina.sh run


# database setup
# ==============

while [ -z "$(curl -s localhost:8080/status | grep '"cassandraAvailable" : true')" ] ;
do
  echo "+++ tomcat log:"
  tail -n 20 ${CATALINA_HOME}/logs/catalina.out
  echo "+++ waiting for cassandra being available to usergrid"
  sleep 2
done

echo "+++ usergrid database setup"
curl --user ${ADMIN_USER}:${ADMIN_PASS} -X PUT http://localhost:8080/system/database/setup

echo "+++ usergrid database bootstrap"
curl --user ${ADMIN_USER}:${ADMIN_PASS} -X PUT http://localhost:8080/system/database/bootstrap

echo "+++ usergrid superuser setup"
curl --user ${ADMIN_USER}:${ADMIN_PASS} -X GET http://localhost:8080/system/superuser/setup

echo "+++ create organization and corresponding organization admin account"
curl -D - \
     -X POST  \
     -d "organization=${ORG_NAME}&username=${ORG_NAME}admin&name=${ORG_NAME}admin&email=${ORG_NAME}admin@example.com&password=${ORG_NAME}admin" \
     http://localhost:8080/management/organizations

echo "+++ create admin token with permissions"
export ADMINTOKEN=$(curl -X POST --silent "http://localhost:8080/management/token" -d "{ \"username\":\"${ORG_NAME}admin\", \"password\":\"${ORG_NAME}admin\", \"grant_type\":\"password\"} " | cut -f 1 -d , | cut -f 2 -d : | cut -f 2 -d \")
echo ADMINTOKEN=$ADMINTOKEN

echo "+++ create app"
curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -H "Content-Type: application/json" \
     -X POST -d "{ \"name\":\"${APP_NAME}\" }" \
     http://localhost:8080/management/orgs/${ORG_NAME}/apps


echo "+++ delete guest permissions"
curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X DELETE "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles/guest"

echo "+++ delete default permissions which are too permissive"
curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X DELETE "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles/default" 


echo "+++ create new guest role"
curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X POST "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles" \
     -d "{ \"name\":\"guest\", \"title\":\"Guest\" }"

echo "+++ create new default role, applied to each logged in user"
curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X POST "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles" \
     -d "{ \"name\":\"default\", \"title\":\"User\" }"


echo "+++ create guest permissions required for login"
curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X POST "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles/guest/permissions" \
     -d "{ \"permission\":\"post:/token\" }"

curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X POST "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles/guest/permissions" \
     -d "{ \"permission\":\"post:/users\" }"

curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X POST "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles/guest/permissions" \
     -d "{ \"permission\":\"get:/auth/facebook\" }"

curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X POST "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles/guest/permissions" \
     -d "{ \"permission\":\"get:/auth/googleplus\" }"

echo "+++ create default permissions for a logged in user"
curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X POST "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles/default/permissions" \
     -d "{ \"permission\":\"get,put,post,delete:/users/\${user}/**\" }"

curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X POST "http://localhost:8080/${ORG_NAME}/${APP_NAME}/roles/default/permissions" \
     -d "{ \"permission\":\"post:/notifications\" }"

echo "+++ create user"
curl -D - \
     -H "Authorization: Bearer ${ADMINTOKEN}" \
     -X POST "http://localhost:8080/${ORG_NAME}/${APP_NAME}/users" \
     -d "{ \"username\":\"${ORG_NAME}user\", \"password\":\"${ORG_NAME}user\", \"email\":\"${ORG_NAME}user@example.com\" }"

echo
echo "+++ done"

# log usergrid output do stdout so it shows up in docker logs
tail -f ${CATALINA_HOME}/logs/catalina.out ${CATALINA_HOME}/logs/localhost_access_log.20*.txt
