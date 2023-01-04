# hadolint ignore=DL3007
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest as UBI
# After a `FROM` all ARG values are reset
#  so sync RHEL_VERSION with the container by hand :(
ARG RHEL_VERSION=8

ARG PUPPET_SERVER_VERSION
ARG build_date

ARG EXTRA_REPO_RPMS=https://yum.puppet.com/puppet-release-el-${RHEL_VERSION}.noarch.rpm\ https://dl.fedoraproject.org/pub/epel/epel-release-latest-${RHEL_VERSION}.noarch.rpm
# git is included for folks who want to use git+r10k inside the container
ARG EXTRA_PACKAGES=findutils\ git\ openssl\ tini\ puppetserver-${PUPPET_SERVER_VERSION}\ puppetdb-termini

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.maintainer="????" \
      maintainer="????" \
      org.label-schema.vendor="?????" \
      vendor="?????" \
      org.label-schema.usage="https://path/to/readme/in/vcs-url/probably" \
      org.label-schema.vcs-url="??????" \
      vcs-url="??????" \
      vcs-ref="HEAD" \
      org.label-schema.url="https://github.com/puppetlabs/puppetserver" \
      url="https://github.com/puppetlabs/puppetserver" \
      org.label-schema.version="${PUPPET_SERVER_VERSION}" \
      version="${PUPPET_SERVER_VERSION}" \
      org.label-schema.build-date="${build_date}" \
      build-date="${build_date}" \
      org.label-schema.name="Puppet Server" \
      io.k8s.display-name="Puppet Server" \
      name="Puppet Server" \
      org.label-schema.description="Puppet Server ${PUPPET_SERVER_VERSION} (RHEL${RHEL_VERSION} UBI)" \
      io.k8s.description="Puppet Server ${PUPPET_SERVER_VERSION} (RHEL${RHEL_VERSION} UBI)" \
      description="Puppet Server ${PUPPET_SERVER_VERSION} (RHEL${RHEL_VERSION} UBI)" \
      summary="Puppet Server ${PUPPET_SERVER_VERSION} (RHEL${RHEL_VERSION} UBI)" \
      io.openshift.tags="puppet puppetserver rhel${RHEL_VERSION}" \
      org.label-schema.docker.cmd="docker run -d -p 8140:8140 -v my/code:/etc/puppetlabs/code -v my/ca:/etc/puppetlabs/puppetserver/ca -v my/ssl:/etc/puppetlabs/puppet/ssl -v my/logs:/var/log/puppetlabs/puppetserver --hostname puppet containernamespace/puppetserver"

ENV PUPPETSERVER_JAVA_ARGS="-Xms512m -Xmx512m" \
    PATH="/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:$PATH" \
    SSLDIR="/etc/puppetlabs/puppet/ssl" \
    LOGDIR="/var/log/puppetlabs/puppetserver" \
    PUPPETSERVER_HOSTNAME="" \
    DNS_ALT_NAMES="" \
    PUPPET_MASTERPORT=8140 \
    AUTOSIGN="true" \
    PUPPETSERVER_MAX_ACTIVE_INSTANCES=1 \
    PUPPETSERVER_MAX_REQUESTS_PER_INSTANCE=0 \
    CA_ENABLED="true" \
    CA_HOSTNAME="puppet" \
    CA_MASTERPORT=8140 \
    CA_ALLOW_SUBJECT_ALT_NAMES="false" \
    USE_PUPPETDB="true" \
    PUPPETDB_SERVER_URLS="https://puppetdb:8081" \
    PUPPET_STORECONFIGS_BACKEND="puppetdb" \
    PUPPET_STORECONFIGS="true" \
    PUPPET_REPORTS="puppetdb"

# NOTE: This is just documentation on the expected port/protocol to use.
#       The container can change this via ENV CA_MASTERPORT PUPPET_MASTERPORT
EXPOSE 8140/tcp

# Install the repos and packages then
# install r10k for folks from puppetserver's ruby
# do this as one layer to simplify merge down
# hadolint ignore=DL3041,SC2086
RUN rpm -ivh ${EXTRA_REPO_RPMS} ; microdnf install -y ${EXTRA_PACKAGES} ; microdnf clean all ; puppetserver gem install --no-doc r10k

COPY files/ /
RUN chmod +x /docker-entrypoint.sh /healthcheck-script.sh

HEALTHCHECK --interval=20s --timeout=15s --retries=12 --start-period=3m CMD ["/healthcheck-script.sh"]
ENTRYPOINT ["/usr/bin/tini", "-e", "143", "-g", "--", "/docker-entrypoint.sh"]
CMD ["foreground"]
