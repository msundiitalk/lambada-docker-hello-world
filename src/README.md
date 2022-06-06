
# Reference

[aws-lambda-nodejs-runtime-interface-client](https://github.com/aws/aws-lambda-nodejs-runtime-interface-client)

[A hello world example using a Docker image in AWS Lambda](https://code.mendhak.com/lambda-docker-hello-world/)


- How to build this lambada image

```
docker build -t lambda-docker-hello-world .
```

- How to run this lambada container locally

```
docker run --rm -v ~/.aws-lambda-rie:/aws-lambda -p 8080:8080     --entrypoint /aws-lambda/aws-lambda-rie     lambda-docker-hello-world         /usr/bin/npx aws-lambda-ric index.handler
```


- How to test this lambada container locally

```
aws lambda invoke --region eu-west-1 --endpoint http://localhost:8080 --no-sign-request --function-name function --cli-binary-format raw-in-base64-out --payload '{"a":"b"}' output.txt
```
