FROM centos:7.5.1804

WORKDIR /root

USER root

ADD . /root

RUN yum install -y wget
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
RUN yum install -y google-chrome-stable_current_x86_64.rpm
RUN yum install -y vim
RUN echo "set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936" >> /etc/vimrc
RUN echo "set termencoding=utf-8" >> /etc/vimrc
RUN echo "set encoding=utf-8" >> /etc/vimrc
RUN chmod a+x /root/visit.sh