FROM tibdocker.tibco.com/mashling/mashling-base:latest
ENV MASHLING_MODULE="mashling-cli"
VOLUME  /mashling/${MASHLING_MODULE}
CMD ["/bin/true"]
ADD . /mashling/${MASHLING_MODULE}/

ARG GITHUB_USER_TOKEN

RUN echo "### Installing mashling-cli ###" && \
    cd /mashling && \
    go get -u github.com/TIBCOSoftware/flogo-cli/... && \
    go get -u github.com/TIBCOSoftware/flogo-lib/... && \
    go get -u github.com/TIBCOSoftware/flogo-contrib/... && \
    # Creating folder for mashling-lib and cloning it
    mkdir -p ${GOPATH}/src/github.com/TIBCOSoftware/mashling-lib && \
    git clone https://lakshmimekala:$GITHUB_USER_TOKEN@github.com/TIBCOSoftware/mashling-lib.git ${GOPATH}/src/github.com/TIBCOSoftware/mashling-lib && \
    mkdir -p ${GOPATH}/src/github.com/TIBCOSoftware/${MASHLING_MODULE} && \
#    cp -av mashling-cli/. ${GOPATH}/src/github.com/TIBCOSoftware/${MASHLING_MODULE}/ && \
    cp -av mashling-cli/. ${GOPATH}/src/github.com/TIBCOSoftware/ && \
    # will only fetch dependencies as mashling-cli source code is already in GOPATH   
    go get github.com/TIBCOSoftware/${MASHLING_MODULE}/... && \
    go install github.com/TIBCOSoftware/${MASHLING_MODULE}/... && \
    mashling help
