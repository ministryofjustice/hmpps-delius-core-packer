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





## GitHub Actions

An action to delete the branch after merge has been added.
Also an action that will tag when branch is merged to master
See https://github.com/anothrNick/github-tag-action

```
Bumping

Manual Bumping: Any commit message that includes #major, #minor, or #patch will trigger the respective version bump. If two or more are present, the highest-ranking one will take precedence.

Automatic Bumping: If no #major, #minor or #patch tag is contained in the commit messages, it will bump whichever DEFAULT_BUMP is set to (which is minor by default).

Note: This action will not bump the tag if the HEAD commit has already been tagged.
```

## AMI Users

| aws_account_ids             |              |
|-----------------------------|--------------|
| alfresco-dev                | 563502482979 |
| delius-core-non-prod        | 723123699647 |
| eng-dev                     | 895523100917 |
| eng-prod                    | 077643444046 |
| hmpps-delius-auto-test      | 431912413968 |
| hmpps-delius-int            | 645753425509 |
| hmpps-delius-mis-dev        | 479759138745 |
| hmpps-delius-mis-test       | 349354156492 |
| hmpps-delius-perf           | 130975965028 |
| hmpps-delius-po-test1       | 716683748953 |
| hmpps-delius-pre-prod       | 010587221707 |
| hmpps-delius-prod           | 050243167760 |
| hmpps-delius-stage          | 205048117103 |
| hmpps-delius-test           | 728765553488 |
| hmpps-delius-training       | 330914586320 |
| hmpps-delius-training-test  | 130847504577 |
| hmpps-sandpit               | 434401102446 |
| mis-non-prod                | 479759138745 |
| pcs-tools                   | 766455809178 |
