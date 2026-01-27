# Official Docker images are in the form library/<app> while non-official
# images are in the form <user>/<app>.
FROM docker.io/library/debian:buster-slim AS build-stage

###
# For a list of pre-defined annotation keys and value types see:
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
#
# Note: Additional labels are added by the build workflow.
###
# github@cisa.dhs.gov is a very generic email distribution, and it is
# unlikely that anyone on that distribution is familiar with the
# particulars of your repository.  It is therefore *strongly*
# suggested that you use an email address here that is specific to the
# person or group that maintains this repository; for example:
# LABEL org.opencontainers.image.authors="vm-dev@gwe.cisa.dhs.gov"
LABEL org.opencontainers.image.authors="github@cisa.dhs.gov"
LABEL org.opencontainers.image.vendor="Cybersecurity and Infrastructure Security Agency"

###
# Unprivileged user setup variables
###
ARG CISA_UID=2048
ARG CISA_GID=${CISA_UID}
ARG CISA_USER="cisa"
ENV CISA_GROUP=${CISA_USER}
ENV CISA_HOME="/var/${CISA_USER}"

###
# Remove existing apt SourceList configuration and add in one configured
# to use the Debian Archive. This is necessary because the Debian Buster
# apt repository was archived.
###
RUN rm /etc/apt/sources.list
COPY src/archive.list /etc/apt/sources.list.d/

###
# Ensure preinstalled packages are at their latest versions.
# We do this because the base image is not being updated and does not have the latest
# packages installed.
###
RUN apt-get update --quiet --quiet \
    && apt-get upgrade --yes --quiet --quiet

###
# Install packages necessary to install the MongoDB shell.
# We can safetly skip the update since we did so in the previous step.
###
RUN apt-get install --yes --no-install-recommends --quiet --quiet \
      apt-transport-https \
      ca-certificates \
      software-properties-common

###
# Install the MongoDB shell from the official MongoDB apt repository.
# We must update to get the package lists after adding the new source.
###
COPY src/mongodb.list /etc/apt/sources.list.d/
RUN apt-get update --quiet --quiet \
    && apt-get install --yes --no-install-recommends --quiet --quiet \
      mongodb-org-shell

###
# Install Python 2 core system packages.
###
RUN apt-get install --yes --no-install-recommends --quiet --quiet \
      python-pip \
      python-setuptools \
      python-wheel \
      python2 \
      python2-dev \
      python2-minimal

###
# Install the system packages necessary to run cisagov/cyhy-core.
# We can safetly skip the update since we did so in the previous step.
###
RUN apt-get install --yes --no-install-recommends --quiet --quiet \
      # PyCrypto
      python-crypto \
      python-dateutil \
      python-docopt \
      python-geoip2 \
      python-maxminddb \
      python-netaddr \
      python-pandas \
      python-progressbar \
      # The versions available are >= 3 but the cyhy-core package currently has
      # a requirement of < 3. When the cyhy-core package supports a more recent
      # version of PyMongo, this should be enabled.
      # python-pymongo \
      python-six \
      python-unidecode \
      # PyYAML
      python-yaml

###
# Install the cisagov/cyhy-core package requirements.
###
COPY src/requirements.txt /tmp
RUN pip install --no-cache-dir --requirement /tmp/requirements.txt \
    && rm /tmp/requirements.txt

###
# Clean up apt cache to reduce image size.
###
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

###
# Create unprivileged user
###
RUN groupadd --system --gid ${CISA_GID} ${CISA_GROUP} \
    && useradd --create-home --system \
       --uid ${CISA_UID} --gid ${CISA_GID} \
       --home-dir ${CISA_HOME} ${CISA_USER}

###
# Prepare to run
###
WORKDIR ${CISA_HOME}
USER ${CISA_USER}:${CISA_GROUP}
