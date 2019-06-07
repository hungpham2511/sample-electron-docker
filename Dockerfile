FROM node

# dependencies
RUN apt-get update && \
	apt-get -y --no-install-recommends install libgtkextra-dev libgconf2-dev libnss3 libasound2 \
	libxtst-dev libxss1 libgtk-3-bin software-properties-common\
	&& apt-get clean -qq && rm -rf /var/lib/apt/lists/*

# User and permissions
ARG user=hung
ARG group=hung
ARG uid=999
ARG gid=999
ARG home=/home/${user}
RUN mkdir -p /etc/sudoers.d \
    && groupadd -g ${gid} ${group} \
    && useradd -d ${home} -u ${uid} -g ${gid} -m -s /bin/bash ${user} \
    && echo "${user} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/sudoers_${user}
USER ${user}
RUN mkdir ${home}/app

WORKDIR ${home}/app
COPY --chown=hung ./package.json package.json
RUN yarn install
COPY --chown=hung . .

