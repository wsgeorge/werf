---
title: Image naming
sidebar: reference
permalink: reference/registry/image_naming.html
author: Artem Kladov <artem.kladov@flant.com>
---

Dapp builds and tags docker images to run and push in a registry. For tagging images dapp uses a `REPO` and image tag parameters (`--tag-*`) in the following commands:
* [Tag commands]({{ site.baseurl }}/reference/registry/tag.html)
* [Push commands]({{ site.baseurl }}/reference/registry/push.html)
* [Pull commands]({{ site.baseurl }}/reference/registry/pull.html)
* [Cleaning commands]({{ site.baseurl }}/reference/registry/cleaning.html)
* [Deploy commands]({{ site.baseurl }}/reference/deploy/deployment_to_kubernetes.html#dapp-kube-deploy)

## REPO parameter

For all commands related to a docker registry, dapp uses a single parameter named `REPO`. Using this parameter dapp constructs a [docker repository](https://docs.docker.com/glossary/?term=repository) as follows:

* If dapp project contains nameless dimg, dapp uses `REPO` as docker repository.
* Otherwise, dapp constructs docker repository name for each dimg by following template `REPO/DIMG_NAME`.

E.g., if there is unnamed dimg in a dappfile and `REPO` is `registry.flant.com/sys/backend` then the docker repository name is the `registry.flant.com/sys/backend`.  If there are two dimgs in a dappfile — `server` and `worker`, then docker repository names are:
* `registry.flant.com/sys/backend/server` for `server` dimg;
* `registry.flant.com/sys/backend/worker` for `worker` dimg.

## Image tag parameters

In a Docker world, a tag is a creating an alias for existent docker image. In Dapp world tagging creates **a new image layer** with the specified name. In this image layer labels dapp stores internal service information about tagging schema. This information is referred to as image **meta-information**. Dapp uses this internal information from images in [deploying]({{ site.baseurl }}/reference/deploy/deployment_to_kubernetes.html#dapp-kube-deploy) and [cleaning]({{ site.baseurl }}/reference/registry/cleaning.html) processes.

### --tag-ci

Tag works only in GitLab environment. 

The [docker tag](https://docs.docker.com/glossary/?term=tag) name is based on a GitLab CI variable `CI_COMMIT_TAG`  or `CI_COMMIT_REF_NAME`.

The `CI_COMMIT_TAG` environment variable presents only when building git tag. In this case, dapp creates an image and marks it as a built image for git tag (by adding **meta-information** into newly created docker layer).

If the `CI_COMMIT_TAG` environment variable is absent, then dapp uses the `CI_COMMIT_REF_NAME` environment variable to get the name of building git branch. In this case, dapp creates an image and marks it as a built image for git branch (by adding **meta-information** into newly created docker layer).

After getting git tag or git branch name, dapp applies [slug](#slug) transformation rules if this name doesn't meet with the slug requirements. This behavior allows using tags and branches with arbitrary names in Gitlab like `review/fix#23`.

Option `--tag-ci` is the most recommended way for building in CI.

### --tag-build-id

Tag works only in GitLab environment.

The tag name based on the unique id of the current GitLab job from `CI_JOB_ID` environment variable.

### --tag-branch

The tag name based on a current git branch. Dapp looks for the current commit id in the local git repository where dappfile located.

After getting git branch name, dapp apply [slug](#slug) transformation rules if tag name doesn't meet with the slug requirements. This behavior allows using branches with arbitrary names like `my/second_patch`.

### --tag-commit

The tag name based on a current git commit id (full-length SHA hashsum). Dapp looks for the current commit id in the local git repository where dappfile located.

### --tag|--tag-slug TAG

`--tag TAG` and `--tag-slug TAG` is an alias of each other.

The tag name based on a specified TAG in the parameter.

Dapp applies [slug](#slug) transformation rules to TAG, and if it doesn't meet with the slug requirements. This behavior allows using text with arbitrary chars as a TAG.

### --tag-plain TAG

The tag name based on a specified TAG in the parameter.

Dapp doesn't apply [slug](#slug) transformation rules to TAG, even though it contains inappropriate symbols and doesn't meet with the slug requirements. Pay attention, that this behavior could lead to an error.

### Default values

By default, dapp use `latest` as a docker tag for all images of dappfile.

### Combining parameters

Any combination of tag parameters can be used simultaneously for [tag commands]({{ site.baseurl }}/reference/registry/tag.html) and [push commands]({{ site.baseurl }}/reference/registry/push.html). In the result, there is a separate image for each tag parameter of each dimg in a project.

## Examples

### Two dimgs

Given dappfile with 2 dimgs — backend and frontend.

The following command:

```bash
dapp dimg tag registry.hello.com/web/core/system --tag-plain v1.2.0
```

produces the following image names respectively:
* `registry.hello.com/web/core/system/backend:v1.2.0`;
* `registry.hello.com/web/core/system/frontend:v1.2.0`.

### Two dimgs in GitLab job

Given Dappfile with 2 dimgs — backend and frontend.

The following command runs in GitLab job for git branch named `core/feature/ADD_SETTINGS`:
```bash
dapp dimg push registry.hello.com/web/core/system --tag-ci
```

Image names in the result are:
* `registry.hello.com/web/core/system/backend:core-feature-add-settings-c3fd80df`
* `registry.hello.com/web/core/system/frontend:core-feature-add-settings-c3fd80df`

Each image name converts according to slug rules with adding murmurhash.

### Unnamed dimg in GitLab job

Given dappfile with single unnamed dimg. The following command runs in GitLab job for git-tag named `v2.3.1`:

```bash
dapp dimg push registry.hello.com/web/core/queue --tag-ci
```

Image name in the result is `registry.hello.com/web/core/queue:v2-3-1-5cb8b0a4`

Image name converts according to slug rules with adding murmurhash, because of points symbols in the tag `v2.3.1` (points don't meet the requirements).

### Two dimgs with multiple tags in GitLab job

Given dappfile with 2 dimgs — backend and frontend. The following command runs in GitLab job for git-branch named `rework-cache`:

```bash
dapp dimg push registry.hello.com/web/core/system --tag-ci --tag "feature/using_cache" --tag-plain my-test-branch
```

The command produces 6 image names for each dimg name and each tag-parameter (two dimgs by three tags):
* `registry.hello.com/web/core/system/backend:rework-cache`
* `registry.hello.com/web/core/system/frontend:rework-cache`
* `registry.hello.com/web/core/system/backend:feature-using-cache-81644ed0`
* `registry.hello.com/web/core/system/frontend:feature-using-cache-81644ed0`
* `registry.hello.com/web/core/system/backend:my-test-branch`
* `registry.hello.com/web/core/system/frontend:my-test-branch`

For `--tag` parameter image names are converting, but for `--tag-ci` parameter image names are not converting, because branch name meets `rework-cache` the requirements.

## Slug

In some cases, text from environment variables or parameters can't be used AS IS because it can contain unacceptable symbols. E.g., git branch name needs to contain only acceptable symbols (see more [here](https://git-scm.com/docs/git-check-ref-format)) and so on. For excluding unacceptable symbols from a text, getting text unique and more human-readable dapp has the `slug` command.

Dapp uses the `slug` command in image tagging and deployment process. You can also use `dapp slug` command (see syntax below) upon your needs.

### Algorithm

Dapp checks the text for compliance with slug **requirements**, and if text complies with slug requirements — dapp doesn't modify it. Otherwise, dapp performs **transformations** of the text to comply the requirements and add a dash symbol followed by a hash suffix based on the source text. A hash algorithm is a [MurmurHash](https://en.wikipedia.org/wiki/MurmurHash).

A text complies with slug requirements if:
* it has only lowercase alphanumerical ASCII characters and dashes;
* it doesn't start or end with dashes;
* it doesn't contain multiple dashes sequences.

The following steps perform, when dapp apply transformations of the text in slug:
* Converting UTF-8 latin characters to their ASCII counterpart;
* Replacing some special symbols with dash symbol (`~><+=:;.,[]{}()_&`);
* Removing all non-recognized characters (leaving lowercase alphanumerical characters and dashes);
* Removing starting and ending dashes;
* Reducing multiple dashes sequences to one dash.

### Syntax

```bash
dapp slug STRING
```

Transform `STRING` according to the slug algorithm (see above) and prints the result.

### Examples

The text `feature-fix-2` isn't transforming because it meets the slug requirements. The result is:

```bash
$ dapp slug 'feature-fix-2'
feature-fix-2
```

The text `branch/one/!@#4.4-3` transforming because it doesn't meet the slug requirements and hash adding. The result is:

```bash
$ dapp slug 'branch/one/!@#4.4-3'
branch-one-4-4-3-5589e04f
```