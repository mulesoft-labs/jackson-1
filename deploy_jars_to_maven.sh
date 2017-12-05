#!/bin/sh

set -o nounset

repository_id_url_to="$1" # in the format <repo_id>::<repo_url>
settings_path="$2"

outputDir=dist
repository_id_to=$(echo $repository_id_url_to | awk -F "::" '{print $1}' )
repository_url_to=$(echo $repository_id_url_to | awk -F "::" '{print $2}' )

maven_settings=""

if [ -z "$settings_path" ]; then
    echo "Using maven config from the local machine."
else
    echo "Using maven settings passed from Jenkins."
    maven_settings="--settings $settings_path"
fi

for artifact_path in dist/*.pom; do

    artifact_name_with_pom_extension=${artifact_path##*/}
    artifact_name=${artifact_name_with_pom_extension%.*}
    packaging=jar

    mvn org.apache.maven.plugins:maven-deploy-plugin:2.8.2:deploy-file -DpomFile=$outputDir/$artifact_name_with_pom_extension -Dfile=$outputDir/${artifact_name}.jar -Dpackaging=$packaging -DrepositoryId=$repository_id_to -Durl=$repository_url_to ${maven_settings}
    mvn org.apache.maven.plugins:maven-deploy-plugin:2.8.2:deploy-file -DpomFile=$outputDir/$artifact_name_with_pom_extension -Dfile=$outputDir/${artifact_name}-javadoc.jar -Dpackaging=$packaging -Dclassifier=javadoc -DrepositoryId=$repository_id_to -Durl=$repository_url_to ${maven_settings}
    mvn org.apache.maven.plugins:maven-deploy-plugin:2.8.2:deploy-file -DpomFile=$outputDir/$artifact_name_with_pom_extension -Dfile=$outputDir/${artifact_name}-sources.jar -Dpackaging=$packaging -Dclassifier=sources  -DrepositoryId=$repository_id_to -Durl=$repository_url_to ${maven_settings}

done


