# frozen_string_literal: true

require "fileutils"

module DmUniboCommon
  class DockerGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    desc "Install Docker Compose files and development commands"

    def copy_compose_files
      copy_file "compose.yaml", "compose.yaml"
      copy_file "compose.dev.yaml", "compose.dev.yaml"
    end

    def copy_commands
      copy_file "docker-build", "bin/docker-build"
      copy_file "docker-dev", "bin/docker-dev"
      FileUtils.chmod 0o755, destination_path("bin/docker-build")
      FileUtils.chmod 0o755, destination_path("bin/docker-dev")
    end
  end
end
