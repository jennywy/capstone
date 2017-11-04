#!/bin/bash

API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/appointments"
curl "${API}${URL_PATH}" \
  --include \
  --request POST \
  --header "Content-Type: application/json" \
  --header "Authorization: Token token=${TOKEN}" \
  --data '{
    "appointment": {
      "name": "'"${NAME}"'",
      "phone_number": "'"${NUMBER}"'",
      "time": "'"${TIME}"'"
    }
  }'

echo
# TOKEN=BAhJIiVmYjBhZmZiMDAxODc3OWNhZGVhODFlZmZhMTU1MGI4OQY6BkVG--f1cd54c9c30cb8bc90dc6312d3e3678339d23999 NAME="TEST" NUMBER="1" TIME="2017-01-01 12:00:00"
