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
      "time": "'"${TIME}"'",
      "reminder": "'"${REMINDER}"'"
    }
  }'

echo
# TOKEN=BAhJIiU5YjljZTMwYzE5ZTVmNDAyOTQyZWY1NTg2MWZiNDM0ZQY6BkVG--397ebaddb94d0e8a6e9d22bd5c81fe87c8b18b51 NAME="TEST" NUMBER="1" TIME="2017-01-01 12:00:00" REMINDER="reminder" sh scripts/apts/create.sh
