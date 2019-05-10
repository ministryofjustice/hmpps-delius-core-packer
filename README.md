# hmpps-delius-core-packer
Packer Repository for our Delius Core base AMIS

## Notes:

References in the Jenkins file and ansible roles for

    -e ARTIFACT_BUCKET \
    -e ZAIZI_BUCKET

    "bucket": "{{env `ARTIFACT_BUCKET`}}",
    "wl_bucket": "{{env `ZAIZI_BUCKET` }}"

    "-e artifact_bucket={{user `bucket`}}",
    "-e wl_artefact_bucket={{user `wl_bucket`}}"

are define in the Jenkin configuration init scripts as follows (six times over)

    export ARTIFACT_BUCKET=tf-eu-west-2-hmpps-eng-dev-config-s3bucket
    export ZAIZI_BUCKET=tf-eu-west-2-hmpps-eng-dev-artefacts-s3bucket

So the buckets are located in the Engineering account.
