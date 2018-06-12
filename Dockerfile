FROM node:9

ENV CHROME_VERSION=67.0.3396.79-1

RUN apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg \
	--no-install-recommends \
	&& curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
	&& apt-get update && apt-get install -y \
	google-chrome-stable=$CHROME_VERSION \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64.deb
RUN dpkg -i dumb-init_*.deb

# Add a user to run prerender and launch chrome with
RUN groupadd -r prerender && useradd -r -g prerender -G audio,video prerender \
    && mkdir -p /home/prerender && chown -R prerender:prerender /home/prerender

USER prerender
WORKDIR /home/prerender



WORKDIR /home/prerender

COPY package.json /home/prerender
RUN npm install && npm cache clean --force
COPY . /home/prerender

CMD [ "npm", "start" ]

EXPOSE 3000
