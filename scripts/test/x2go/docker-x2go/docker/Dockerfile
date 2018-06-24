FROM ubuntu
MAINTAINER Tatsuya Kawano

# Please change this value to force the builders at Quay.io/Docker Hub
# to omit the cached Docker images. This will have the same effect to
# adding `--no-cache` to `docker build` command.
#
ENV DOCKERFILE_UPDATED 2017-04-02

RUN (apt-get update && \
     apt-get install -y software-properties-common && \
     add-apt-repository -y ppa:x2go/stable && \
     apt-get update -y && \
     apt-get upgrade -y && \
     apt-get install -y xfce4 && \
     DEBIAN_FRONTEND=noninteractive apt-get install -y \
         x2goserver x2goserver-xsession ttf-dejavu fonts-ipafont-gothic \
         openbox obconf obmenu conky nitrogen \
         sudo gnome-terminal rxvt-unicode-256color \
         firefox emacs)

RUN (mkdir -p /var/run/sshd && \
     sed -ri 's/UseDNS yes/#UseDNS yes/g' /etc/ssh/sshd_config && \
     echo "UseDNS no" >> /etc/ssh/sshd_config)
#     sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
#     sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config)

# Create a user
RUN (useradd -m docker && \
     mkdir -p /home/docker/.ssh && \
     chmod 700 /home/docker/.ssh && \
     chown docker:docker /home/docker/.ssh && \
     mkdir -p /etc/sudoers.d)

ADD ./999-sudoers-docker /etc/sudoers.d/999-sudoers-docker
RUN chmod 440 /etc/sudoers.d/999-sudoers-docker

# Startup script
ADD ./start-sshd.sh /root/start-sshd.sh
RUN chmod 744 /root/start-sshd.sh

### Need to change this!
#RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime

EXPOSE 22
ENTRYPOINT ["/root/start-sshd.sh"]
