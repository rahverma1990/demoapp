#!/bin/bash

   if [ "$TRAVIS_OS_NAME" = "osx" ]; then
    cd builds/mac;
	mkdir -p osx-"${TRAVIS_BUILD_NUMBER}";
	cd osx-"${TRAVIS_BUILD_NUMBER}";
    Gateway=({"envoy-invoker-mashling","inline-gateway","kafka-conditional-gateway","kafka-reference-gateway","KafkaTrigger-To-KafkaActivity-mashling","KafkaTrigger-To-RestActivity-mashling","reference-gateway","RestTrigger-To-KafkaActivity-mashling","rest-conditional-gateway"})

# get length of an array

	tLen=${#Gateway[@]}
		for (( i=0; i<${tLen}; i++ ));
	do
		echo ${Gateway[$i]};
		mashling create -f ../../../../../mashling-cli/samples/"${Gateway[$i]}".json "${Gateway[$i]}";
		cd "${Gateway[$i]}" ;
		pwd ;
		mv bin dist ;
		ls ;
		pwd ;
		mashling build ;
		ls ;		
		scp bin/flogo.json /Users/travis/gopath/src/github.com/TIBCOSoftware/mashling-cicd/samples-recipes/builds/mac/osx-"${TRAVIS_BUILD_NUMBER}"/"${Gateway[$i]}"/dist ;
		scp mashling.json dist ;
		cd dist ;
		ls ;
		cd .. ;
		rm -r bin src vendor pkg ;
		rm mashling.json ;
		ls ;
		cd ..;
	done
    fi
    
   if [ "$TRAVIS_OS_NAME" = "linux" ]; then
    cd builds/linux;
	mkdir -p linux-"${TRAVIS_BUILD_NUMBER}";
	cd linux-"${TRAVIS_BUILD_NUMBER}";
	Gateway=({"envoy-invoker-mashling","inline-gateway","kafka-conditional-gateway","kafka-reference-gateway","KafkaTrigger-To-KafkaActivity-mashling","KafkaTrigger-To-RestActivity-mashling","reference-gateway","RestTrigger-To-KafkaActivity-mashling","rest-conditional-gateway"})

	tLen=${#Gateway[@]}
		for (( i=0; i<tLen; i++ ));
	do
		echo ${Gateway[$i]};
		mashling create -f ../../../../../mashling-cli/samples/"${Gateway[$i]}".json "${Gateway[$i]}";
		cd "${Gateway[$i]}" ;
		pwd ;
		mv bin dist ;
		ls ;
		pwd ;
		mashling build ;
		ls ;		
		scp bin/flogo.json /home/travis/gopath/src/github.com/TIBCOSoftware/mashling-cicd/samples-recipes/builds/linux/linux-"${TRAVIS_BUILD_NUMBER}"/"${Gateway[$i]}"/dist ;
		scp mashling.json dist ;
		cd dist ;
		ls ;
		cd .. ;
		rm -r bin src vendor pkg ;
		rm mashling.json ;
		ls ;
		cd ..;
	done
    fi
