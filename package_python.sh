#!/bin/bash
set -e

if [ -z "$1" ]; then
    version=`./gradlew -q showVersion`
else
    version=$1
fi

set +e
rm -rf build/python/${version}

set -e
home=`pwd`
for dict_type in small core full
do
    temp=build/python/${version}/${dict_type}
    pkg=${temp}/sudachidict_${dict_type}
    mkdir -p ${pkg}
    mkdir ${pkg}/resources
    touch ${pkg}/__init__.py
    cp python/README.md ${temp}
    cp LEGAL ${temp}
    cp LICENSE-2.0.txt ${temp}
    cp python/MANIFEST.in ${temp}
    cp python/setup.py ${temp}
    cat python/INFO.json | sed "s/%%VERSION%%/${version}/g" | sed "s/%%DICT_TYPE%%/${dict_type}/g" > ${temp}/INFO.json
    cd ${temp}
    python setup.py sdist
    cd ${home}
done
