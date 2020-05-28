FROM node:14.3.0-alpine3.10

# Set alpine mirror
RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.4/main/" > /etc/apk/repositories

# Set alpien timezone
ENV TIME_ZONE=Asia/Shanghai \
    LANG="zh_CN.UTF-8" \
    TZ=Asia/Shanghai
RUN apk add --no-cache tzdata \
        && echo "${TIME_ZONE}" > /etc/timezone \
        && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime \
        && apk add --no-cache libstdc++ \
        && echo "export LC_ALL=zh_CN.UTF-8" >> /etc/profile

# Install git
RUN apk add --no-cache git python

# Install hexo
WORKDIR /root
RUN yarn global add hexo-cli \
        && hexo init blog

# Install related dependences
WORKDIR /root/blog
RUN yarn add hexo-admin 
RUN yarn add hexo-renderer-scss

COPY ./themes /root/blog/themes
COPY ./config/_config.yml /root/blog/_config.yml
COPY ./config/_admin-config.yml /root/blog/_admin-config.yml

EXPOSE 4000
CMD ["hexo", "server"] 
