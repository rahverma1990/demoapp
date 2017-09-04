FROM tibdocker.tibco.com/mashling/mashling-cli:latest

WORKDIR $GOPATH/src/github.com/TIBCOSoftware

ARG GITHUB_USER_TOKEN
ARG TRAVIS_BUILD_NUMBER

RUN git clone https://LakshmiMekala:${GITHUB_USER_TOKEN}@github.com/TIBCOSoftware/mashling-cicd.git

WORKDIR $GOPATH/src/github.com/TIBCOSoftware/mashling-cicd/samples-recipes/builds/linux/linux-${TRAVIS_BUILD_NUMBER}/rest-conditional-gateway/dist

RUN chmod 777 rest-conditional-gateway
COPY rest-conditional-gateway $GOPATH
WORKDIR $GOPATH 
ENV PATH $GOPATH/mashling-cicd/samples-recipes/builds/linux/linux-${TRAVIS_BUILD_NUMBER}/rest-conditional-gateway/dist:$PATH	

EXPOSE 9096

CMD ["rest-conditional-gateway"]




