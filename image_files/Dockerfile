FROM golang:alpine3.14
RUN mkdir /app
COPY . /app
WORKDIR /app
#RUN go mod init github.com/cyberark/conjur-api-go/conjurapi
#RUN go mod init github.com/cyberark/conjur-api-go/conjurapi/authn
#RUN go get -u github.com/cyberark/conjur-api-go/conjurapi
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o cnjr .
CMD ["/app/cnjr"]
