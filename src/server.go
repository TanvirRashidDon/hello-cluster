package main

import (
	"net/http"
	"net"
	"time"
	"fmt"
	"html"
	"log"
	"strings"
)

func getClientIp(request *http.Request) string {
	xff := request.Header.Get("X-Forwarded-For")
	if xff != "" {
		ips := strings.Split(xff, ",")
		return strings.TrimSpace(ips[0])
	}

	host, _, _ := net.SplitHostPort(request.RemoteAddr)
	return host
}

func handler (writer http.ResponseWriter, request *http.Request) {
	path := html.EscapeString(request.URL.Path)
	clientIp := getClientIp(request)
	fmt.Println("Client IP: ", clientIp, " -> ", path)
	fmt.Fprintf(writer, "Hello, %q", path)
}

func main() {
	server := &http.Server{
		Addr: ":8090",
		ReadTimeout: 10 * time.Second,
		WriteTimeout: 10 * time.Second,
		MaxHeaderBytes: 1 << 20, // 1 MB
	}

	http.HandleFunc("/api", handler)

	log.Fatal(server.ListenAndServe())
}
