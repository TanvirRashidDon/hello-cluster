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

func resolveClientIp(request *http.Request) string {
	xff := request.Header.Get("X-Forwarded-For")
	if xff != "" {
		ips := strings.Split(xff, ",")
		return strings.TrimSpace(ips[0])
	}

	host, _, _ := net.SplitHostPort(request.RemoteAddr)
	return host
}

func resolveLocalIp() (string, error) {
	interfaces, err := net.Interfaces()
	if err != nil {
		return "", fmt.Errorf("error getting network interfaces: %d", err)
	}

	for _, iface := range interfaces {
		// Ignore interaces that are down or loopback
		if iface.Flags&net.FlagUp ==0 || iface.Flags&net.FlagLoopback !=0 {
			continue
		}

		addresses, err := iface.Addrs()
		if err != nil {
			return "", fmt.Errorf("error getting addresses for interface %s: %w", iface, err)
		}

		for _, address := range addresses {
			if ipNet, ok := address.(*net.IPNet); ok && !ipNet.IP.IsLoopback() {
				if ip := ipNet.IP.To4(); ip != nil {
					return ip.String(), nil
				}
			}
		}
	}

	return "", fmt.Errorf("no valid IP address found")
}

func handler (writer http.ResponseWriter, request *http.Request) {
	path := html.EscapeString(request.URL.Path)
	clientIp := resolveClientIp(request)
	localIp, _ := resolveLocalIp()
	fmt.Println(time.Now(), ": Local IP: ", localIp, " Client IP: ", clientIp, " -> ", path)
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
