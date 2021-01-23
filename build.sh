#!/bin/bash -xe

# This script uses openapi2jsonschema to generate a set of JSON schemas for
# the specified Kubernetes versions in three different flavours:
#
#   X.Y.Z - URL referenced based on the specified GitHub repository
#   X.Y.Z-standalone - de-referenced schemas, more useful as standalone documents
#   X.Y.Z-standalone-strict - de-referenced schemas, more useful as standalone documents, additionalProperties disallowed
#   X.Y.Z-local - relative references, useful to avoid the network dependency

declare -a arr=(
    # Add here the version you want to re-generate
    # master
    # v1.19.X
    v1.19.3
    )

# This list is used only list of already genrated schema definition
# (or when we need to rebuild all definitions)
declare -a arr2=(
    # master
    # v1.19.X
    v1.19.3
    # v1.18.x
    v1.18.1
    v1.18.0
    # v1.17.x
    v1.17.4
    v1.17.3
    v1.17.2
    v1.17.1
    v1.17.0
    # v1.16.x
    v1.16.4
    v1.16.3
    v1.16.2
    v1.16.1
    v1.16.0
    # v1.15.x
    v1.15.7
    v1.15.6
    v1.15.5
    v1.15.4
    v1.15.3
    v1.15.2
    v1.15.1
    v1.15.0
    # v1.14.x
    v1.14.10
    v1.14.9
    v1.14.8
    v1.14.7
    v1.14.6
    v1.14.5
    v1.14.4
    v1.14.3
    v1.14.2
    v1.14.1
    v1.14.0
    # v1.13.x
    v1.13.11
    v1.13.10
    v1.13.9
    v1.13.8
    v1.13.7
    v1.13.6
    v1.13.5
    v1.13.4
    v1.13.3
    v1.13.2
    v1.13.1
    v1.13.0
    # v1.12.x
    v1.12.10
    v1.12.9
    v1.12.8
    v1.12.7
    v1.12.6
    v1.12.5
    v1.12.4
    v1.12.3
    v1.12.2
    v1.12.1
    v1.12.0
)

for version in "${arr[@]}"
do
schema=https://raw.githubusercontent.com/kubernetes/kubernetes/${version}/api/openapi-spec/swagger.json
prefix=https://kubernetesjsonschema.dev/${version}/_definitions.json

docker run -it docker.pkg.github.com/yannh/openapi2jsonschema/openapi2jsonschema:latest -o "${version}-standalone-strict" --expanded --kubernetes --stand-alone --strict "${schema}"
docker run -it docker.pkg.github.com/yannh/openapi2jsonschema/openapi2jsonschema:latest -o "${version}-standalone" --expanded --kubernetes --stand-alone "${schema}"
docker run -it docker.pkg.github.com/yannh/openapi2jsonschema/openapi2jsonschema:latest -o "${version}-local" --expanded --kubernetes "${schema}"
docker run -it docker.pkg.github.com/yannh/openapi2jsonschema/openapi2jsonschema:latest -o "${version}" --expanded --kubernetes --prefix "${prefix}" "${schema}"
docker run -it docker.pkg.github.com/yannh/openapi2jsonschema/openapi2jsonschema:latest -o "${version}-standalone-strict" --kubernetes --stand-alone --strict "${schema}"
docker run -it docker.pkg.github.com/yannh/openapi2jsonschema/openapi2jsonschema:latest -o "${version}-standalone" --kubernetes --stand-alone "${schema}"
docker run -it docker.pkg.github.com/yannh/openapi2jsonschema/openapi2jsonschema:latest -o "${version}-local" --kubernetes "${schema}"
docker run -it docker.pkg.github.com/yannh/openapi2jsonschema/openapi2jsonschema:latest -o "${version}" --kubernetes --prefix "${prefix}" "${schema}"
done
