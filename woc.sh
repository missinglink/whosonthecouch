#!/bin/bash

GIT_REMOTE='https://github.com/whosonfirst-data/whosonfirst-data.git'
LOCAL_DIR='/media/black/tmp/whosonfirst-data'

# detect if this is the first time the script has been run
FIRST_RUN=false
if [ ! -d "$LOCAL_DIR" ]; then FIRST_RUN=true; fi

# clone / fetch latest data from remote
function update {
  if $FIRST_RUN; then git clone --branch master --single-branch --depth 1 -n $GIT_REMOTE $LOCAL_DIR; fi
  cd $LOCAL_DIR
  git fetch
  git checkout 'HEAD'
}

# get the newest commit hash available
function sha_head { git rev-parse 'HEAD'; }

# get the oldest commit hash available
function sha_tail { git rev-list 'HEAD' | tail -n 1; }

# get a list of changes since a specific hash
function sha_diff { git diff --name-status "$1" "$2"; }

update
sha_diff $(sha_tail) $(sha_head)
