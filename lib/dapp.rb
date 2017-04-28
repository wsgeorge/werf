require 'pathname'
require 'fileutils'
require 'tmpdir'
require 'digest'
require 'timeout'
require 'base64'
require 'mixlib/cli'
require 'mixlib/shellout'
require 'securerandom'
require 'excon'
require 'json'
require 'uri'
require 'ostruct'
require 'time'
require 'i18n'
require 'paint'
require 'inifile'
require 'rugged'
require 'rubygems/package'
require 'murmurhash3'
require 'net_status'
require 'yaml'
require 'openssl'
require 'etc'

require 'dapp/version'
require 'dapp/core_ext/hash'
require 'dapp/core_ext/pathname'
require 'dapp/helper/cli'
require 'dapp/helper/trivia'
require 'dapp/helper/sha256'
require 'dapp/helper/net_status'
require 'dapp/prctl'
require 'dapp/error/base'
require 'dapp/error/dapp'
require 'dapp/error/dappfile'
require 'dapp/error/shellout'
require 'dapp/exception/base'
require 'dapp/cli'
require 'dapp/cli/command/base'
require 'dapp/config/directive/base'
require 'dapp/config/config'
require 'dapp/config/error/config'
require 'dapp/dapp/lock'
require 'dapp/dapp/ssh_agent'
require 'dapp/dapp/git_artifact'
require 'dapp/dapp/dappfile'
require 'dapp/dapp/chef'
require 'dapp/dapp/logging/base'
require 'dapp/dapp/logging/process'
require 'dapp/dapp/logging/paint'
require 'dapp/dapp/logging/i18n'
require 'dapp/dapp/deps/base'
require 'dapp/dapp/deps/gitartifact'
require 'dapp/dapp/shellout/streaming'
require 'dapp/dapp/shellout/base'
require 'dapp/dapp'
require 'dapp/deployment'
require 'dapp/deployment/config/directive/mod/group'
require 'dapp/deployment/config/directive/mod/bootstrap'
require 'dapp/deployment/config/directive/base'
require 'dapp/deployment/config/directive/expose'
require 'dapp/deployment/config/directive/namespace/instance_methods'
require 'dapp/deployment/config/directive/namespace'
require 'dapp/deployment/config/directive/app/instance_methods'
require 'dapp/deployment/config/directive/app'
require 'dapp/deployment/config/directive/group'
require 'dapp/deployment/config/directive/deployment'
require 'dapp/deployment/config/directive/bootstrap'
require 'dapp/deployment/config/config'
require 'dapp/deployment/core_ext/hash'
require 'dapp/deployment/mod/namespace'
require 'dapp/deployment/mod/system_environments'
require 'dapp/deployment/app'
require 'dapp/deployment/deployment'
require 'dapp/deployment/kube_base'
require 'dapp/deployment/kube_app'
require 'dapp/deployment/kube_deployment'
require 'dapp/deployment/error/base'
require 'dapp/deployment/error/config'
require 'dapp/deployment/error/app'
require 'dapp/deployment/error/command'
require 'dapp/deployment/error/kubernetes'
require 'dapp/deployment/error/deployment'
require 'dapp/deployment/kubernetes'
require 'dapp/deployment/kubernetes/error'
require 'dapp/deployment/cli/command/base'
require 'dapp/deployment/cli/command/deployment'
require 'dapp/deployment/cli/command/deployment/apply'
require 'dapp/deployment/cli/command/deployment/mrproper'
require 'dapp/deployment/cli/command/deployment/secret_key_generate'
require 'dapp/deployment/cli/command/deployment/secret_generate'
require 'dapp/deployment/cli/command/deployment/minikube_setup'
require 'dapp/deployment/cli/cli'
require 'dapp/deployment/dapp/command/mrproper'
require 'dapp/deployment/dapp/command/apply'
require 'dapp/deployment/dapp/command/secret_key_generate'
require 'dapp/deployment/dapp/command/secret_generate'
require 'dapp/deployment/dapp/command/minikube_setup'
require 'dapp/deployment/dapp/command/common'
require 'dapp/deployment/dapp/dappfile'
require 'dapp/deployment/dapp/dapp'
require 'dapp/deployment/secret'
require 'dapp/dimg'
require 'dapp/dimg/builder'
require 'dapp/dimg/builder/base'
require 'dapp/dimg/builder/chef'
require 'dapp/dimg/builder/chef/cookbook_metadata'
require 'dapp/dimg/builder/chef/berksfile'
require 'dapp/dimg/builder/chef/cookbook'
require 'dapp/dimg/builder/shell'
require 'dapp/dimg/builder/none'
require 'dapp/dimg/build/stage/mod/logging'
require 'dapp/dimg/build/stage/mod/group'
require 'dapp/dimg/build/stage/base'
require 'dapp/dimg/build/stage/ga_base'
require 'dapp/dimg/build/stage/ga_dependencies_base'
require 'dapp/dimg/build/stage/artifact_base'
require 'dapp/dimg/build/stage/artifact_default'
require 'dapp/dimg/build/stage/from'
require 'dapp/dimg/build/stage/import_artifact'
require 'dapp/dimg/build/stage/before_install'
require 'dapp/dimg/build/stage/before_install_artifact'
require 'dapp/dimg/build/stage/ga_archive_dependencies'
require 'dapp/dimg/build/stage/ga_archive'
require 'dapp/dimg/build/stage/install/ga_pre_install_patch_dependencies'
require 'dapp/dimg/build/stage/install/ga_pre_install_patch'
require 'dapp/dimg/build/stage/install/install'
require 'dapp/dimg/build/stage/install/ga_post_install_patch_dependencies'
require 'dapp/dimg/build/stage/install/ga_post_install_patch'
require 'dapp/dimg/build/stage/after_install_artifact'
require 'dapp/dimg/build/stage/before_setup'
require 'dapp/dimg/build/stage/before_setup_artifact'
require 'dapp/dimg/build/stage/setup/ga_pre_setup_patch_dependencies'
require 'dapp/dimg/build/stage/setup/ga_pre_setup_patch'
require 'dapp/dimg/build/stage/setup/setup'
require 'dapp/dimg/build/stage/setup/ga_post_setup_patch_dependencies'
require 'dapp/dimg/build/stage/setup/ga_post_setup_patch'
require 'dapp/dimg/build/stage/after_setup_artifact'
require 'dapp/dimg/build/stage/ga_latest_patch'
require 'dapp/dimg/build/stage/docker_instructions'
require 'dapp/dimg/build/stage/ga_artifact_patch'
require 'dapp/dimg/build/stage/build_artifact'
require 'dapp/dimg/cli/command/base'
require 'dapp/dimg/cli/command/dimg'
require 'dapp/dimg/cli/command/dimg/build'
require 'dapp/dimg/cli/command/dimg/push'
require 'dapp/dimg/cli/command/dimg/spush'
require 'dapp/dimg/cli/command/dimg/tag'
require 'dapp/dimg/cli/command/dimg/list'
require 'dapp/dimg/cli/command/dimg/build_context'
require 'dapp/dimg/cli/command/dimg/build_context/export'
require 'dapp/dimg/cli/command/dimg/build_context/import'
require 'dapp/dimg/cli/command/dimg/stages'
require 'dapp/dimg/cli/command/dimg/stages/flush_local'
require 'dapp/dimg/cli/command/dimg/stages/flush_repo'
require 'dapp/dimg/cli/command/dimg/stages/cleanup_local'
require 'dapp/dimg/cli/command/dimg/stages/cleanup_repo'
require 'dapp/dimg/cli/command/dimg/stages/push'
require 'dapp/dimg/cli/command/dimg/stages/pull'
require 'dapp/dimg/cli/command/dimg/run'
require 'dapp/dimg/cli/command/dimg/cleanup'
require 'dapp/dimg/cli/command/dimg/bp'
require 'dapp/dimg/cli/command/dimg/mrproper'
require 'dapp/dimg/cli/command/dimg/stage_image'
require 'dapp/dimg/cli/cli'
require 'dapp/dimg/config/directive/base'
require 'dapp/dimg/config/directive/dimg/instance_methods'
require 'dapp/dimg/config/directive/dimg/validation'
require 'dapp/dimg/config/directive/dimg'
require 'dapp/dimg/config/directive/artifact_dimg'
require 'dapp/dimg/config/directive/dimg_group_base'
require 'dapp/dimg/config/directive/dimg_group'
require 'dapp/dimg/config/directive/artifact_group'
require 'dapp/dimg/config/directive/artifact_base'
require 'dapp/dimg/config/directive/git_artifact_local'
require 'dapp/dimg/config/directive/git_artifact_remote'
require 'dapp/dimg/config/directive/artifact'
require 'dapp/dimg/config/directive/chef'
require 'dapp/dimg/config/directive/shell/dimg'
require 'dapp/dimg/config/directive/shell/artifact'
require 'dapp/dimg/config/directive/docker/base'
require 'dapp/dimg/config/directive/docker/dimg'
require 'dapp/dimg/config/directive/docker/artifact'
require 'dapp/dimg/config/directive/mount'
require 'dapp/dimg/config/config'
require 'dapp/dimg/dapp/command/common'
require 'dapp/dimg/dapp/command/build'
require 'dapp/dimg/dapp/command/bp'
require 'dapp/dimg/dapp/command/cleanup'
require 'dapp/dimg/dapp/command/mrproper'
require 'dapp/dimg/dapp/command/stage_image'
require 'dapp/dimg/dapp/command/list'
require 'dapp/dimg/dapp/command/push'
require 'dapp/dimg/dapp/command/run'
require 'dapp/dimg/dapp/command/spush'
require 'dapp/dimg/dapp/command/tag'
require 'dapp/dimg/dapp/command/stages/common'
require 'dapp/dimg/dapp/command/stages/cleanup_local'
require 'dapp/dimg/dapp/command/stages/cleanup_repo'
require 'dapp/dimg/dapp/command/stages/flush_local'
require 'dapp/dimg/dapp/command/stages/flush_repo'
require 'dapp/dimg/dapp/command/stages/push'
require 'dapp/dimg/dapp/command/stages/pull'
require 'dapp/dimg/dapp/command/build_context/export'
require 'dapp/dimg/dapp/command/build_context/import'
require 'dapp/dimg/dapp/command/build_context/common'
require 'dapp/dimg/dapp/dappfile'
require 'dapp/dimg/dapp/dapp'
require 'dapp/dimg/docker_registry'
require 'dapp/dimg/docker_registry/base/request'
require 'dapp/dimg/docker_registry/base/authorization'
require 'dapp/dimg/docker_registry/base'
require 'dapp/dimg/docker_registry/default'
require 'dapp/dimg/error/base'
require 'dapp/dimg/error/dimg'
require 'dapp/dimg/error/build'
require 'dapp/dimg/error/tar_writer'
require 'dapp/dimg/error/rugged'
require 'dapp/dimg/error/registry'
require 'dapp/dimg/error/chef'
require 'dapp/dimg/error/lock'
require 'dapp/dimg/error/config'
require 'dapp/dimg/error/command'
require 'dapp/dimg/exception/base'
require 'dapp/dimg/exception/introspect_image'
require 'dapp/dimg/exception/registry'
require 'dapp/dimg/lock/base'
require 'dapp/dimg/lock/file'
require 'dapp/dimg/filelock'
require 'dapp/dimg/git_repo/base'
require 'dapp/dimg/git_repo/own'
require 'dapp/dimg/git_repo/remote'
require 'dapp/dimg/git_artifact'
require 'dapp/dimg/image/argument'
require 'dapp/dimg/image/docker'
require 'dapp/dimg/image/stage'
require 'dapp/dimg/image/scratch'
require 'dapp/dimg/dimg/git_artifact'
require 'dapp/dimg/dimg/path'
require 'dapp/dimg/dimg/tags'
require 'dapp/dimg/dimg/stages'
require 'dapp/dimg/dimg'
require 'dapp/dimg/artifact'

module Dapp
  def self.root
    File.expand_path('../..', __FILE__)
  end
end
