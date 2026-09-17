#!/bin/sh
set -eu
cd "$(dirname "$0")/vendor"
npm ci
./node_modules/.bin/esbuild web/js/main.ts --bundle --outfile=../assets/main.js --target=es2017 --jsx-factory=JSX.createElement --minify
./node_modules/.bin/esbuild web/js/start.ts --bundle --outfile=../assets/start.js --target=es2017 --jsx-factory=JSX.createElement --minify
./node_modules/.bin/esbuild web/js/code-only.ts --bundle --outfile=../assets/code-only.js --target=es2017 --jsx-factory=JSX.createElement --minify
