# Makefile for SSL/TLS key and certificate generation

# Default target
.PHONY: all
all:
	@echo "Available targets:"
	@echo "  keys - Generate SSL/TLS key and certificate"
	@echo "         Usage: make keys KEY=/path/to/key.key CERT=/path/to/cert.crt"

# Generate SSL/TLS keys and certificates
.PHONY: keys
keys:
	@if [ -z "$(KEY)" ]; then \
		echo "Error: KEY parameter is required"; \
		echo "Usage: make keys KEY=/path/to/key.key CERT=/path/to/cert.crt"; \
		exit 1; \
	fi
	@if [ -z "$(CERT)" ]; then \
		echo "Error: CERT parameter is required"; \
		echo "Usage: make keys KEY=/path/to/key.key CERT=/path/to/cert.crt"; \
		exit 1; \
	fi
	@echo "Generating SSL/TLS key at $(KEY)"
	@mkdir -p $(dir $(KEY))
	@openssl genrsa -out $(KEY) 2048
	@echo "Generating SSL/TLS certificate at $(CERT)"
	@mkdir -p $(dir $(CERT))
	@openssl req -new -x509 -key $(KEY) -out $(CERT) -days 365 -subj "/CN=localhost" -nodes

# Clean up generated files
.PHONY: clean
clean:
	@echo "Usage: make clean KEY=/path/to/key.key CERT=/path/to/cert.crt"
	@if [ ! -z "$(KEY)" ] && [ -f "$(KEY)" ]; then \
		rm -f $(KEY); \
		echo "Removed $(KEY)"; \
	fi
	@if [ ! -z "$(CERT)" ] && [ -f "$(CERT)" ]; then \
		rm -f $(CERT); \
		echo "Removed $(CERT)"; \
	fi

.PHONY: help
help:
	@echo "Makefile targets:"
	@echo "  all   - Display available targets (default)"
	@echo "  keys  - Generate SSL/TLS key and certificate"
	@echo "          Usage: make keys KEY=/path/to/key.key CERT=/path/to/cert.crt"
	@echo "  clean - Remove generated key and certificate files"
	@echo "          Usage: make clean KEY=/path/to/key.key CERT=/path/to/cert.crt"
	@echo "  help  - Display this help message"

