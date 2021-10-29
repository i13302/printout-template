#!/bin/sh 
set -eux

PDFFILE='paper.pdf'
TODAY=`date "+%Y%m%d-%H%M%S_%a"`

# create release
res=`curl -H "Authorization: token $GITHUB_TOKEN" -X POST https://api.github.com/repos/$GITHUB_REPOSITORY/releases \
-d "
{
  \"tag_name\": \"v$TODAY\",
  \"target_commitish\": \"$GITHUB_SHA\",
  \"name\": \"v$TODAY\",
  \"draft\": false,
  \"prerelease\": false
}"`

# extract release id
rel_id=`echo ${res} | jq '.id'`

# upload built pdf
curl -H "Authorization: token $GITHUB_TOKEN" -X POST https://uploads.github.com/repos/$GITHUB_REPOSITORY/releases/${rel_id}/assets?name=\"${TODAY}_$PDFFILE``\"\
  --header 'Content-Type: application/pdf'\
  --upload-file $PDFFILE
