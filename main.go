package main

import (
	"context"
	"log"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

// HandleRequest Handle requests
func HandleRequest(ctx context.Context, e events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

	log.Println("Hello World!")
	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusAccepted,
		Body:       "Hello World!",
	}, nil
}

func main() {
	lambda.Start(HandleRequest)
}
