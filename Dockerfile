# Volt Grid: Apache Solr
#
# Base: centos7
# Version: 1.0.0
#

FROM centos:centos7
MAINTAINER Tim Robinson <tim@voltgrid.com>

ENV SOLR_VERSION=4.10.4

RUN \
  yum -q -y install epel-release && \
  yum -q -y install tar wget java-1.7.0-openjdk-headless && \
  yum -q -y clean all && \
  rm -rf /tmp/* /var/cache/yum/

RUN groupadd solr --gid 48 && \
  useradd solr --uid 48 --gid 48 -M -d /opt/solr && \
  wget -qO- https://archive.apache.org/dist/lucene/solr/${SOLR_VERSION}/solr-${SOLR_VERSION}.tgz | tar -C /opt -zx && \
  cp -a /opt/solr-${SOLR_VERSION}/example/. /opt/solr && \
  cp -a /opt/solr-${SOLR_VERSION}/contrib /opt/solr && \
  cp -a /opt/solr-${SOLR_VERSION}/dist /opt/solr && \
  ln -s /opt/solr/contrib /opt/contrib && \
  ln -s /opt/solr/dist /opt/dist && \
  sed -i 's/\.\.\/\.\.\/\.\.\/\(contrib\|dist\)/\.\.\/\.\.\/\1/g' /opt/solr/solr/collection1/conf/solrconfig.xml && \
  chown -R solr:solr /opt/solr/logs && \
  rm -rf /opt/solr-${SOLR_VERSION} && \
  chown -R solr:solr /opt/solr/solr-webapp && \
  mkdir /opt/solr/solr/collection1/data && \
  chown -R solr:solr /opt/solr/solr/collection1/data/

VOLUME /opt/solr/solr/collection1

EXPOSE 8983
USER solr
WORKDIR /opt/solr
CMD ["/usr/bin/java","-Dsolr.contrib.dir=/opt/solr/contrib","-Dsolr.dist.dir=/opt/solr/dist","-Dsolr.solr.home=/opt/solr/solr","-jar","/opt/solr/start.jar"]

