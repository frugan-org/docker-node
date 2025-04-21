#!/bin/bash

#https://blog.dockbit.com/templating-your-dockerfile-like-a-boss-2a84a67d28e9

deploy() {
	str="
  s!%%TAG%%!$TAG!g;
"

	sed -r "$str" "$1"
}

#https://docs.strapi.io/dev-docs/installation/cli
# Only Active LTS or Maintenance LTS versions are supported (currently v18 and v20).
# Odd-number releases of Node, known as "current" versions of Node.js, are not supported (e.g. v19, v21).
TAGS=(
	18-alpine
	19-alpine
	20-alpine
	21-alpine
	22-alpine
)

ENTRYPOINT=entrypoint.sh

IFS='
'
# shellcheck disable=SC2048
for TAG in ${TAGS[*]}; do

	if [ -d "$TAG" ]; then
		rm -Rf "$TAG"
	fi

	mkdir "$TAG"
	deploy Dockerfile.template >"$TAG"/Dockerfile

	if [ -f "$ENTRYPOINT" ]; then
		cp $ENTRYPOINT "$TAG"
	fi

done
