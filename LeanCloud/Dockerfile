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

# 如何使用
# 1. 构建镜像
#       docker build -t visit_leancloud:v1 LeanCloud
# 2. 创建访问的url列表，下面的脚本生成的文件路径为 ../url.list
#       perl generateUrl.pl
# 3. 运行容器，并将上一步生成的 url.list 挂载到容器内
#       docker run -dit --name visitor --privileged=true -v $(ROOT=$(dirname ../url.list); cd ${ROOT}; pwd)/url.list:/root/url.list visit_leancloud:v1 /usr/sbin/init
# 4. 进入到容器内
#       docker exec -it visitor bash
# 5. 在容器内运行脚本
#       /root/visit.sh
