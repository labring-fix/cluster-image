#!/bin/bash

set -e

# dockers.sh only builds a file named Dockerfile; this version dir ships
# fileMigration.dockerfile, so copy it into place before the build runs.
cp fileMigration.dockerfile Dockerfile
