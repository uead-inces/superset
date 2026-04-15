#!/usr/bin/env bash
# [Licencia omitida para brevedad, mantener igual que el original]

set -e
apt update
	apt install -y git
# Mantener la instalación de dependencias para Puppeteer
if [ "$PUPPETEER_SKIP_CHROMIUM_DOWNLOAD" = "false" ]; then
    
    apt install -y chromium
fi

if [ "$BUILD_SUPERSET_FRONTEND_IN_DOCKER" = "true" ]; then
    echo "Building Superset frontend in dev mode inside docker container"
    cd /app/superset-frontend

    if [ "$NPM_RUN_PRUNE" = "true" ]; then
        echo "Running npm run prune"
        npm run prune
    fi

    # --- EL PARCHE TÉCNICO AQUÍ ---
    echo "Running npm install with force"
    # 1. Eliminamos carpetas temporales que bloquean el proceso en Windows
    rm -rf node_modules/.staging node_modules/.cache
    npm cache clean --force
    # 2. Instalación con parches:
    # --legacy-peer-deps: Ignora el conflicto React 16 (plugin) vs 17 (Superset)
    # --no-save: No intenta escribir en el disco del host (evita ENOTEMPTY)
    npm install --force
    # ------------------------------

    echo "Start webpack dev server"
    npm run dev-server

else
    echo "Skipping frontend build steps - YOU NEED TO RUN IT MANUALLY ON THE HOST!"
    echo "https://superset.apache.org/docs/contributing/development/#webpack-dev-server"
fi