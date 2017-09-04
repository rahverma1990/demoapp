#!/bin/sh

	git config user.email "lmekala@tibco.com";
	git config user.name "LakshmiMekala"

	if [ "$TRAVIS_OS_NAME" = "osx" ]; then
#	cd ../mashling-cicd/samples-recipes/builds/mac/osx-"${TRAVIS_BUILD_NUMBER}"/ ;
  	git stash;
	git checkout master;
	git add .; 
	git commit -m "uploading binaries-${TRAVIS_BUILD_NUMBER}";
	git push --set-upstream origin master;
    fi
	
    if [ "$TRAVIS_OS_NAME" = "linux" ]; then
#	cd ../mashling-cicd/samples-recipes/builds/linux/linux-"${TRAVIS_BUILD_NUMBER}"/ ;
	git stash;
	git checkout master;
	git add .; 
	git commit -m "uploading binaries-${TRAVIS_BUILD_NUMBER}";
	git push --set-upstream origin master;
    fi
    
    
