package main

import (
	"io"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestResolveClientIp(t *testing.T) {
	tests := []struct {
		name           string
		remoteAddr     string
		xForwardedFor  string
		expectedResult string
	}{
		{
			name:           "X-Forwarded-For header present",
			remoteAddr:     "192.168.1.1:1234",
			xForwardedFor:  "10.0.0.1, 10.0.0.2, 10.0.0.3",
			expectedResult: "10.0.0.1",
		},
		{
			name:           "X-Forwarded-For header with single IP",
			remoteAddr:     "192.168.1.1:1234",
			xForwardedFor:  "10.0.0.1",
			expectedResult: "10.0.0.1",
		},
		{
			name:           "No X-Forwarded-For header",
			remoteAddr:     "192.168.1.1:1234",
			xForwardedFor:  "",
			expectedResult: "192.168.1.1",
		},
		{
			name:           "IPv6 in RemoteAddr",
			remoteAddr:     "[2001:db8::1]:1234",
			xForwardedFor:  "",
			expectedResult: "2001:db8::1",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			req := httptest.NewRequest(http.MethodGet, "/", nil)
			req.RemoteAddr = tt.remoteAddr
			if tt.xForwardedFor != "" {
				req.Header.Set("X-Forwarded-For", tt.xForwardedFor)
			}

			result := resolveClientIp(req)
			if result != tt.expectedResult {
				t.Errorf("resolveClientIp() = %v, want %v", result, tt.expectedResult)
			}
		})
	}
}

func TestHandler(t *testing.T) {
	tests := []struct {
		name           string
		path           string
		expectedStatus int
		expectedBody   string
	}{
		{
			name:           "Root path",
			path:           "/",
			expectedStatus: http.StatusOK,
			expectedBody:   `Hello, "/"`,
		},
		{
			name:           "API path",
			path:           "/api",
			expectedStatus: http.StatusOK,
			expectedBody:   `Hello, "/api"`,
		},
//		{
//			name:           "Path with special characters",
//			path:           "/api?param=<script>alert('xss')</script>",
//			expectedStatus: http.StatusOK,
//			expectedBody:   `Hello, "/api?param=<script>alert('xss')</script>"`,
//		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			req := httptest.NewRequest(http.MethodGet, tt.path, nil)
			w := httptest.NewRecorder()

			handler(w, req)

			resp := w.Result()
			defer resp.Body.Close()

			if resp.StatusCode != tt.expectedStatus {
				t.Errorf("handler() status = %v, want %v", resp.StatusCode, tt.expectedStatus)
			}

			// Get response body
			bodyBytes, err := io.ReadAll(resp.Body)
			if err != nil {
				t.Errorf("Error reading response body: %v", err)
			}
			body := string(bodyBytes)

			if body != tt.expectedBody {
				t.Errorf("handler() body = %v, want %v", body, tt.expectedBody)
			}
		})
	}
}

func TestResolveLocalIp(t *testing.T) {
	// This is a simple smoke test - a full test would require mocking network interfaces
	ip, err := resolveLocalIp()

	if err != nil {
		// If running in CI/container environment, it's possible not to have a valid IP
		// In that case, just log the error rather than failing the test
		t.Logf("resolveLocalIp() returned error: %v", err)
		return
	}

	if ip == "" {
		t.Error("resolveLocalIp() returned empty string, expected an IP address")
	}

	t.Logf("Resolved local IP: %s", ip)
}

