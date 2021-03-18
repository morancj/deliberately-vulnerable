FROM ubuntu:14.04


# Install outdated software
ARG NPM_VERSION
ENV NPM_VERSION ${NPM_VERSION:-1.3.10~dfsg-1}
ARG NODEJS_VERSION
ENV NODEJS_VERSION ${NODEJS_VERSION:-0.10.25~dfsg2-2ubuntu1.2}
ARG NODEJS_LEGACY_VERSION
ENV NODEJS_LEGACY_VERSION ${NODEJS_LEGACY_VERSION:-0.10.25~dfsg2-2ubuntu1}

ENV VERSIONED_PACKAGES \
 npm=${NPM_VERSION}\
 nodejs=${NODEJS_VERSION}\
 nodejs-legacy=${NODEJS_LEGACY_VERSION}

# Install software and cleanup
# Tell apt not to use interactive prompts
RUN export DEBIAN_FRONTEND=noninteractive && \
#  apt-get update && \
  apt-get update

RUN apt-get install -y --no-install-recommends \
# Install temporary packages
 ${VERSIONED_PACKAGES} \
 && \
# Clean up package cache in this layer
# Remove dependencies which are no longer required
 apt-get --purge autoremove -y && \
# Clean package cache
 apt-get clean -y && \
# Restore interactive prompts
 unset DEBIAN_FRONTEND && \
# Remove cache files
 rm -rf \
 /tmp/* \
 /var/cache/* \
 /var/log/* \
 /var/lib/apt/lists/*

#Set root´s password to something silly
RUN echo 'root:root' | chpasswd
