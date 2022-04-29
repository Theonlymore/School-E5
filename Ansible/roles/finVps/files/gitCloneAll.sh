#!/bin/bash

######################
# Clone all repositories (private and public) from a GitHub user
# 
# Usage:
# 
# chmod +x cloneall.sh
# cloneall.sh username password
# 
# Created by: hlorand

rm -r /apps/backup/github/*

USERNAME="theonlymore"
PASSWORD="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"

# Generate auth header
AUTH=$(echo -n $USERNAME:$PASSWORD | base64)

# Get repository URLs
curl -iH "Authorization: Basic "$AUTH https://api.github.com/user/repos | grep -w clone_url > repos.txt

# Clean URLs
# - remove " and ,
# - print the second column
cat repos.txt | tr -d \"\, | awk '{print $2}'  > repos_clean.txt

# Insert username:password after protocol:// to generate clone URLs
cat repos_clean.txt |  sed "s/:\/\/git/:\/\/$USERNAME\:$PASSWORD\@git/g" > repos_clone.txt

while read FILE; do
	git -C /apps/backup/github/ clone $FILE
done <repos_clone.txt

rm repos.txt
rm repos_clone.txt
rm repos_clean.txt 