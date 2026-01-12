# UCLI Website Makefile (Astro + Tailwind)

.PHONY: dev build preview clean install help

# Default target
help:
	@echo "UCLI Website - Astro Commands"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  install   Install npm dependencies"
	@echo "  dev       Start development server (http://localhost:4321)"
	@echo "  build     Build for production to ./dist"
	@echo "  preview   Preview production build locally"
	@echo "  clean     Remove build artifacts and node_modules"
	@echo "  help      Show this help message"

# Marker file for installed dependencies
node_modules/.installed: package.json package-lock.json
	npm install
	@touch node_modules/.installed

# Install dependencies
install: node_modules/.installed

# Start development server with hot reload
dev: node_modules/.installed
	npm run dev

# Build for production
build: node_modules/.installed
	npm run build

# Preview production build
preview: node_modules/.installed
	npm run preview

# Clean build artifacts
clean:
	rm -rf dist/ node_modules/.cache/

# Full clean (including node_modules)
clean-all:
	rm -rf dist/ node_modules/

# Rebuild (clean + install + build)
rebuild: clean install build
