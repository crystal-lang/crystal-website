#!/bin/bash -e
TARGET_BUCKET="${1}"
while read legacy_url
do
  pretty_url="/${legacy_url%.html}/"

  # put an empty object just for the redirection - see https://stackoverflow.com/a/63293266
  aws s3api put-object --bucket "$TARGET_BUCKET" --key "${legacy_url}" --website-redirect-location "${pretty_url}"
done
