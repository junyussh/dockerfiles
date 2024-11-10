FROM rockylinux:8

# RUN sed -e 's|^mirrorlist=|#mirrorlist=|g' \
#     -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.sjtug.sjtu.edu.cn/rocky|g' \
#     -i.bak \
#     /etc/yum.repos.d/Rocky-*.repo

RUN dnf -y update && \
    dnf -y install 'dnf-command(config-manager)' && \
    dnf -y config-manager --set-enabled powertools && \
    dnf -y install epel-release

RUN dnf -y install --allowerasing --nobest \
    curl \
    gcc \
    glibc-langpack-en \
    graphviz \
    java-11-openjdk-devel \
    langpacks-en \
    nano \
    python3-devel \
    python3-GitPython \
    python3-pika \
    python3-pip \
    python3-cryptography \
    python3-PyYAML \
    sudo \
    supervisor \
    tar \
    vim \
    wget
     
ADD ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# ADD ./config/wrapdocker /usr/local/bin/wrapdocker
ADD ./config/htcondor-wrapper /usr/local/bin/htcondor-wrapper
RUN chmod +x /usr/local/bin/htcondor-wrapper
RUN useradd -m -s /bin/bash --create-home user
# RUN usermod -aG docker user

# Locale and timezone
ENV LANG en_US.UTF-8
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# HTCondor
RUN dnf -y config-manager --add-repo=https://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-stable-rhel8.repo && \
    rpm --import https://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor && \
    dnf -y install condor minicondor && \
    sed -i 's/condor@/user@/g' /etc/condor/config.d/00-minicondor
    
RUN echo "user:user" | chpasswd
RUN usermod -a -G condor,wheel user
RUN chmod -R g+w /var/{lib,log,lock,run}/condor
RUN echo -e "user ALL=(ALL)       NOPASSWD:ALL\n" >> /etc/sudoers
ADD ./config/10-dynamic-slots /etc/condor/config.d/10-dynamic-slots

# Pegasus
RUN wget -O /tmp/pegasus-5.0.8-1.el8.x86_64.rpm https://download.pegasus.isi.edu/pegasus/rhel/8/x86_64/pegasus-5.0.8-1.el8.x86_64.rpm
# COPY pegasus-*-*.rpm /tmp/
RUN dnf -y install /tmp/pegasus-*-*.`arch`.rpm

# Apptainer
RUN dnf install -y apptainer

# COPY entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh
USER root
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
# ENTRYPOINT ["/entrypoint.sh"]

# USER user
# WORKDIR /home/user