#!/bin/sh

SCRIPTROOT=$(cd `dirname $0` && pwd)
version=${version:-"v0.1.0"}

function main {
    echo "Detecting images for version $version..."

    istioimages=$(cat $SCRIPTROOT/../istio/$version/base/istio.yaml | grep "image: " | awk -F ': ' '{print $2}' | tr -d '"')
   
    for i in $istioimages; do
        parse_image $i $repo istio
    done
        
}

# Parses the image string to make sure it's an actual image
function parse_image() {
    slashcount=$(echo $1 | grep -o "/" | wc -l )
    if [ $slashcount -gt 0 ]
    then
        columncount=$(echo $1 | grep -o ":" | wc -l )
        if [ $columncount -gt 0 ] 
        then
            fetch_image $1 $2 $slashcount $3 $version
        fi
    fi
    
}

# Fetches the image
# params
# $1 image to pull
# $2 new repo base
# $3 how many slashes ie: docker.io/alpine:latest vs alpine:latest
# $4 istio or knative
# $5 version
function fetch_image() {
    if [ "$3" == "2" ] 
    then
        repoimage=$(echo $1 | awk -F '/' '{print $2 "-" $3'})
        newtag=$2/$repoimage        
    else
        repoimage=$(echo $1 | awk -F '/' '{print $1 "-" $2'})
        newtag=$2/$repoimage
    fi

    echo "Executing: docker pull $1"
    docker pull $1    
    echo "Executing docker tag $1 $newtag"
    docker tag $1 $newtag
    echo "Executing docker push $newtag"
    docker push $newtag
    echo "Replacing manifests"
    
    case `uname -s` in
	Darwin)
        sed -i '' -e 's@'$1'@'$newtag'@g' $SCRIPTROOT/../$4/$5/airgap/*.yaml
        ;;

	*)
        sed -i 's@'$1'@'$newtag'@g' $SCRIPTROOT/../$4/$5/airgap/*.yaml
        ;;
esac
}

# --------------------------------------------------------------
# Main code starts here
if [ -z "$repo" ]
then
    echo "ERROR \$repo variable must be set to docker registry root ie: 
export repo=docker.io/alekssaul"
else
    main
fi

