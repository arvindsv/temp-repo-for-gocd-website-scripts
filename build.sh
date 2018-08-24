#!/bin/bash

destination_repo="$1"
destination_branch="$2"
upstream_repo="${3:-https://github.com/gocd/www.go.cd.git}"

set -xe

git remote add upstream "$upstream_repo" && git fetch upstream
git rebase upstream/master

git remote add destination "$destination_repo" && git fetch destination

export NOKOGIRI_USE_SYSTEM_LIBRARIES=1;
bundle install --jobs 4 --path .bundle && bundle exec rake publish REMOTE_NAME=destination BRANCH_NAME="$destination_branch" --trace

