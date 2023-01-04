# OCI Container for [puppetlabs/puppetserver](https://github.com/puppetlabs/puppetserver)

The Dockerfile for this image is available [here][1].

You can run a copy of Puppet Server with the following Docker command:

    docker run --name puppet --hostname puppet ???????/puppetserver

Although it is not strictly necessary to name the container `puppet`, this is
useful when working with the other Puppet images, as they will look for a master
on that hostname by default.

If you would like to start the Puppet Server with your own Puppet code, you can
mount your own directory at `/etc/puppetlabs/code`:

    docker run --name puppet --hostname puppet -v ./code:/etc/puppetlabs/code/ ???????/puppetserver

You can find out more about Puppet Server in the [official documentation][2].

NOTE: There are known issues around the Mainline Linux kernel 5.6 - 5.10!
      Rather than patch the fix in place here, you should upgrade your
      system.  RHEL 8.6+ and Ubuntu 20.04+ hosts are expected to be OK.

## Configuration

The following environment variables are supported:

| Name                                       | Default    | Usage
|--------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **PUPPETSERVER_HOSTNAME**                  | UNSET      | The DNS name used on the masters SSL certificate - sets the `certname` and `server` in puppet.conf                                                    |
| **DNS_ALT_NAMES**                          | UNSET      | Additional DNS names to add to the masters SSL certificate.<br> **Note** only effective on initial run when certificates are generated               |
| **PUPPET_MASTERPORT**                      | `8140`     | The port of the puppet master                                                                                                                         |
| **AUTOSIGN**                               | `true`     | Whether or not to enable autosigning on the puppetserver instance. Valid values are `true`, `false`, and `/path/to/autosign.conf`.                    |
| **CA_ENABLED**                             | `true`     | Whether or not this puppetserver instance has a running CA (Certificate Authority)                                                                    |
| **CA_HOSTNAME**                            | `puppet`   | The DNS hostname for the puppetserver running the CA.<br> **Note** Does nothing unless `CA_ENABLED=false`                                            |
| **CA_MASTERPORT**                          | `8140`     | The listening port of the CA.<br> **Note** Does nothing unless `CA_ENABLED=false`                                                                     |
| **CA_ALLOW_SUBJECT_ALT_NAMES**             | `false`    | Whether or not SSL certificates containing Subject Alternative Names should be signed by the CA.  <br> **Note** Does nothing unless `CA_ENABLED=true` |
| **PUPPET_REPORTS**                         | `puppetdb` | Sets `reports` in puppet.conf                                                                                                                         |
| **PUPPET_STORECONFIGS**                    | `true`     | Sets `storeconfigs` in puppet.conf                                                                                                                    |
| **PUPPET_STORECONFIGS_BACKEND**            | `puppetdb` | Sets `storeconfigs_backend` in puppet.conf                                                                                                            |
| **USE_PUPPETDB**                           | `true`     | Whether to connect to puppetdb.<br> **Note** Sets `PUPPET_REPORTS` to `log` and `PUPPET_STORECONFIGS` to `false` if those unset                       |
| **PUPPETDB_SERVER_URLS**                   | `https://puppetdb:8081` | The `server_urls` to set in `/etc/puppetlabs/puppet/puppetdb.conf`                                                                       |
| **PUPPETSERVER_MAX_ACTIVE_INSTANCES**      | `1`        | The maximum number of JRuby instances allowed                                                                                                         |
| **PUPPETSERVER_MAX_REQUESTS_PER_INSTANCE** | `0`        | The maximum HTTP requests a JRuby instance will handle in its lifetime (disable instance flushing)                                                    |
| **PUPPETSERVER_JAVA_ARGS**                 | `-Xms512m -Xmx512m` | Arguments passed directly to the JVM when starting the service                                                                               |

## Initialization Scripts

If you would like to do additional initialization, add a directory called `/docker-custom-entrypoint.d/` and fill it with `.sh` scripts.
These scripts will be executed at the end of the entrypoint script, before the service is ran.

## Persistance 

If you plan to use the in-server CA, restarting the container can cause the server's keys and certificates to change, causing agents and the server to stop trusting each other. To prevent this, you can persist the default cadir, `/etc/puppetlabs/puppetserver/ca`. For example, `-v $PWD/ca-ssl:/etc/puppetlabs/puppetserver/ca`.

## Tooling

This container also ships with `r10k` and `git` to ease these deployment options

[1]: ?????
[2]: https://puppet.com/docs/puppetserver/latest/services_master_puppetserver.html
