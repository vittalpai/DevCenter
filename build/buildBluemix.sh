#!/bin/bash

# only proceed script when started not by pull request (PR)
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e

## First, build for GitHub Pages
# build site with jekyll, by default to `_site' folder
rm -rf _site/*
bundle exec jekyll build --config _config.yml,build/_configBluemix.yml -d _site --profile
rm -f _site/*.log
# bundle exec htmlproof ./_site --disable-external --href-ignore '#'

# cleanup
rm -rf ../mfpsamples.github.ibm.com.generated-bluemix

#clone `generated-bluemix' branch of the repository
git clone git@github.ibm.com:MFPSamples/mfpsamples.github.ibm.com.git --branch generated-bluemix --single-branch ../mfpsamples.github.ibm.com.generated-bluemix
# copy generated HTML site to `generated-bluemix' branch
rm -rf ../mfpsamples.github.ibm.com.generated-bluemix/*
cp -R _site/* ../mfpsamples.github.ibm.com.generated-bluemix

# commit and push generated content to `generated-bluemix' branch
# since repository was cloned in write mode with token auth - we can push there
cd ../mfpsamples.github.ibm.com.generated-bluemix
git config user.email "nathanh@il.ibm.com"
git config user.name "Nathan Hazout Travis"
git add -A .
git commit -a -m "Travis Build $TRAVIS_BUILD_NUMBER"
git push --quiet origin generated-bluemix