package main

import (
	"github.com/minio/minio-go"
	"log"
    "fmt"
)

func main() {
	endpoint := "10.102.1.140:9000"
	accessKeyID := "minio"
	secretAccessKey := "miniostorage"
	useSSL := false

	// Initialize minio client object.
	minioClient, err := minio.New(endpoint, accessKeyID, secretAccessKey, useSSL)
	if err != nil {
		log.Fatalln(err)
	}
	log.Printf("%#v\n", minioClient)
	n, err := minioClient.FPutObject("mybucket", "myobject.csv", "/tmp/test", "application/text")
	if err != nil {
		fmt.Println(err)
		return
	}
    fmt.Println(n)
}
