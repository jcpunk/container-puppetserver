#! /bin/sh

hostpubkey=$(puppet config print hostcert)
localcacert=$(puppet config print localcacert)

### Print configuration for troubleshooting
echo "System configuration values:"
# shellcheck disable=SC2039 # Docker injects $HOSTNAME
echo "* HOSTNAME: '${HOSTNAME}'"
echo "* hostname -f: '$(hostname -f)'"
echo "* PUPPETSERVER_HOSTNAME: '${PUPPETSERVER_HOSTNAME}'"
echo "* DNS_ALT_NAMES: '${DNS_ALT_NAMES}'"
echo "* Host Certificate: '${hostpubkey}'"
echo "* CA Certificate: '${localcacert}'"
echo "* SSLDIR: '${SSLDIR}'"
echo "* PUPPET_MASTERPORT: '${PUPPET_MASTERPORT}'"

altnames="-certopt no_subject,no_header,no_version,no_serial,no_signame,no_validity,no_issuer,no_pubkey,no_sigdump,no_aux"

if [ -f "${localcacert}" ]; then
  echo "* CA Certificate Details:"
  # shellcheck disable=SC2086 # $altnames shouldn't be quoted
  su puppet -s /bin/sh -c "openssl x509 -subject -issuer -text -noout -in '${SSLDIR}/certs/ca.pem' ${altnames}"
fi

if [ -f "${hostpubkey}" ]; then
  echo "* Host Certificate Details:"
  # shellcheck disable=SC2086 # $altnames shouldn't be quoted
  su puppet -s /bin/sh -c "openssl x509 -subject -issuer -text -noout -in '${SSLDIR}/certs/${certname}' ${altnames}"
fi
