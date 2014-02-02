#!/bin/bash

declare -A tracked_jobs

tracked_jobs["test_status"]="it should be found"
tracked_jobs["testttt_status"]="it should be found"

if [ -n "${tracked_jobs["test_status"]}" ]
then
    echo "YES!"
fi

if [ -n "${tracked_jobs["test_ss"]}" ]
then
    echo "NO!! :("
fi

# It outputs both YES and NO, which would seem as both keys exist in the array when they clearly do not.
