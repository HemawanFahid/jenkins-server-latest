ADD file:ff01c6dedb67cf22e9b0735e099b9b6367770c4880941862cc7ec0e979b4118b in / 

CMD ["bash"]
RUN /bin/sh -c apt-get update   && apt-get install -y --no-install-recommends     ca-certificates     curl     git     gnupg     gpg     libfontconfig1     libfreetype6     ssh-client     tini     unzip   && rm -rf /var/lib/apt/lists/* # buildkit
RUN /bin/sh -c curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh -o /tmp/script.deb.sh   && bash /tmp/script.deb.sh   && rm -f /tmp/script.deb.sh   && apt-get install -y --no-install-recommends     git-lfs   && rm -rf /var/lib/apt/lists/*   && git lfs install # buildkit

ENV LANG=C.UTF-8

ARG TARGETARCH
ARG COMMIT_SHA
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG http_port=8080
ARG agent_port=50000
ARG JENKINS_HOME=/var/jenkins_home
ARG REF=/usr/share/jenkins/ref

ENV JENKINS_HOME=/var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT=50000
ENV REF=/usr/share/jenkins/ref

RUN |10 TARGETARCH=amd64 COMMIT_SHA=c62ce445e4302eaa5c00c4d51a26c6e4c3fb5427 user=jenkins group=jenkins uid=1000 gid=1000 http_port=8080 agent_port=50000 JENKINS_HOME=/var/jenkins_home REF=/usr/share/jenkins/ref /bin/sh -c mkdir -p $JENKINS_HOME   && chown ${uid}:${gid} $JENKINS_HOME   && groupadd -g ${gid} ${group}   && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -l -m -s /bin/bash ${user} # buildkit

VOLUME [/var/jenkins_home]

RUN |10 TARGETARCH=amd64 COMMIT_SHA=c62ce445e4302eaa5c00c4d51a26c6e4c3fb5427 user=jenkins group=jenkins uid=1000 gid=1000 http_port=8080 agent_port=50000 JENKINS_HOME=/var/jenkins_home REF=/usr/share/jenkins/ref /bin/sh -c mkdir -p ${REF}/init.groovy.d # buildkit

ARG JENKINS_VERSION

ENV JENKINS_VERSION=2.371

ARG JENKINS_SHA=1163c4554dc93439c5eef02b06a8d74f98ca920bbc012c2b8a089d414cfa8075
ARG JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/2.371/jenkins-war-2.371.war

RUN |13 TARGETARCH=amd64 COMMIT_SHA=c62ce445e4302eaa5c00c4d51a26c6e4c3fb5427 user=jenkins group=jenkins uid=1000 gid=1000 http_port=8080 agent_port=50000 JENKINS_HOME=/var/jenkins_home REF=/usr/share/jenkins/ref JENKINS_VERSION=2.371 JENKINS_SHA=ecb0610c40a1a7dd24939bfcc63022552e04b72dde64683bf57a1e90e3306522 JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/2.371/jenkins-war-2.371.war /bin/sh -c curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war   && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" >/tmp/jenkins_sha   && sha256sum -c --strict /tmp/jenkins_sha   && rm -f /tmp/jenkins_sha # buildkit

ENV JENKINS_UC=https://updates.jenkins.io

ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals


RUN |13 TARGETARCH=amd64 COMMIT_SHA=c62ce445e4302eaa5c00c4d51a26c6e4c3fb5427 user=jenkins group=jenkins uid=1000 gid=1000 http_port=8080 agent_port=50000 JENKINS_HOME=/var/jenkins_home REF=/usr/share/jenkins/ref JENKINS_VERSION=2.371 JENKINS_SHA=ecb0610c40a1a7dd24939bfcc63022552e04b72dde64683bf57a1e90e3306522 JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/2.371/jenkins-war-2.371.war /bin/sh -c chown -R ${user} "$JENKINS_HOME" "$REF" # buildkit

ARG PLUGIN_CLI_VERSION=2.12.9
ARG PLUGIN_CLI_URL=https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.12.9/jenkins-plugin-manager-2.12.9.jar

RUN |15 TARGETARCH=amd64 COMMIT_SHA=c62ce445e4302eaa5c00c4d51a26c6e4c3fb5427 user=jenkins group=jenkins uid=1000 gid=1000 http_port=8080 agent_port=50000 JENKINS_HOME=/var/jenkins_home REF=/usr/share/jenkins/ref JENKINS_VERSION=2.371 JENKINS_SHA=ecb0610c40a1a7dd24939bfcc63022552e04b72dde64683bf57a1e90e3306522 JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/2.371/jenkins-war-2.371.war PLUGIN_CLI_VERSION=2.12.9 PLUGIN_CLI_URL=https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.12.9/jenkins-plugin-manager-2.12.9.jar /bin/sh -c curl -fsSL ${PLUGIN_CLI_URL} -o /opt/jenkins-plugin-manager.jar # buildkit
EXPOSE map[8080/tcp:{}]
EXPOSE map[50000/tcp:{}]

ENV COPY_REFERENCE_FILE_LOG=/var/jenkins_home/copy_reference_file.log
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH=/opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

COPY /javaruntime /opt/java/openjdk # buildkit
USER jenkins

COPY jenkins-support /usr/local/bin/jenkins-support # buildkit
COPY jenkins.sh /usr/local/bin/jenkins.sh # buildkit
COPY tini-shim.sh /sbin/tini # buildkit
COPY jenkins-plugin-cli.sh /bin/jenkins-plugin-cli # buildkit


ENTRYPOINT ["/usr/bin/tini" "--" "/usr/local/bin/jenkins.sh"]
COPY install-plugins.sh /usr/local/bin/install-plugins.sh # buildkit
LABEL org.opencontainers.image.vendor=Jenkins project org.opencontainers.image.title=Official Jenkins Docker image org.opencontainers.image.description=The Jenkins Continuous Integration and Delivery server org.opencontainers.image.version=2.371 org.opencontainers.image.url=https://www.jenkins.io/ org.opencontainers.image.source=https://github.com/jenkinsci/docker org.opencontainers.image.revision=c62ce445e4302eaa5c00c4d51a26c6e4c3fb5427 org.opencontainers.image.licenses=MIT
