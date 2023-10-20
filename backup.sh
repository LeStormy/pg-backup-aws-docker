#!/bin/bash

GNUPGHOME=/tmp/gnupg
export GNUPGHOME

TARBALL_NAME="klara-$CLUSTER_NAME-backup-$(date +%Y-%m-%d-%H-%M-%S).tar.gz"

echo "dumping DB"
pg_dump "$DB_URL" > "database_dump.sql"
echo "tarballing"
tar -czvf "$TARBALL_NAME" database_dump.sql

echo "gpging"
gpg --recipient-file /tmp/gnupg/pubkey.gpg --encrypt "$TARBALL_NAME"

echo "aws pushing"
AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" aws s3 cp "$TARBALL_NAME.gpg" s3://$BUCKET_NAME --endpoint-url https://s3.gra.io.cloud.ovh.net

