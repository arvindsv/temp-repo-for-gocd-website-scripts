#!/bin/bash

set -xe

if [ "$(eval "echo $REPO_CHECK_ENV_VAR")" = "false" -a "$GO_TRIGGER_USER" = "changes" ]; then
  echo "Not building. It looks like nothing has changed since last time."
  exit 0
fi

destination_repo="$1"
destination_branch="$2"
upstream_repo="${3:-https://github.com/gocd/www.go.cd.git}"

git remote add upstream "$upstream_repo" && git fetch upstream

git branch branch-with-code
git reset --hard upstream/master
git merge branch-with-code
git log -n 1

git remote add destination "$destination_repo" && git fetch destination

export NOKOGIRI_USE_SYSTEM_LIBRARIES=1;
bundle install --jobs 4 --path .bundle && bundle exec rake publish REMOTE_NAME=destination BRANCH_NAME="$destination_branch" --trace

