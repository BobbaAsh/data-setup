#!/usr/bin/env ruby -wU

PYTHON_VERSION = "3.8.5"

# NOTE(ssaunier): This script needs https://github.com/lewagon/setup to be cloned as well
MAC_OS = %w[
  setup_instructions
  setup/remote_tools
  setup/osx_command_line_tools
  setup/github
  homebrew
  setup/osx_sublime_text
  setup/osx_oh_my_zsh
  github_rsa
  dotfiles
  sublime_conf
  ssh_osx
  osx_python
  osx_virtualenv
  pip
  docker
  alumni
  setup/osx_slack
  kata
].freeze

WINDOWS = %w[setup_instructions
  setup/wsl2_prereq_intro
  setup/wsl2_prereq_win10
  setup/wsl2_prereq_win_version
  setup/wsl2_prereq_virtualization
  setup/github
  setup/remote_tools
  setup/wsl2_install_wsl
  setup/wsl2_vscode
  setup/wsl2_windows_terminal
  setup/wsl2_git
  setup/wsl2_oh_my_zsh
  github_rsa
  dotfiles
  setup/wsl_browser_variable
  ubuntu_python
  osx_virtualenv
  pip
  ubuntu_docker
  setup/ubuntu_inotify
  setup/ubuntu_extra
  alumni
  setup/ubuntu_slack
  kata].freeze

LINUX = %w[
  setup_instructions
  setup/remote_tools
  setup/github
  setup/ubuntu_git
  setup/ubuntu_sublime_text
  ubuntu_oh_my_zsh
  github_rsa
  dotfiles
  sublime_conf
  ubuntu_python
  osx_virtualenv
  pip
  ubuntu_docker
  setup/ubuntu_inotify
  setup/ubuntu_extra
  alumni
  setup/ubuntu_slack
  kata
]

filenames = {
  "WINDOWS.md" => WINDOWS,
  "macOS.md" => MAC_OS,
  "LINUX.md" => LINUX,
}

WINDOWS_SUBS = {
  "<CODE_EDITOR>" => "Visual Studio Code",
  "<CODE_EDITOR_CMD>" => "code"
}

DEFAULT_SUBS = {
  "<CODE_EDITOR>" => "Sublime Text",
  "<CODE_EDITOR_CMD>" => "stt"
}

subs = {
  "WINDOWS.md" => WINDOWS_SUBS,
  "macOS.md" => DEFAULT_SUBS,
  "LINUX.md" => DEFAULT_SUBS,
}

filenames.each do |filename, partials|
  File.open(filename.to_s, "w:utf-8") do |f|
    partials.each do |partial|
      match_data = partial.match(/setup\/(?<partial>[0-9a-z_]+)/)
      if match_data
        require 'open-uri'
        content = URI.open(File.join("https://raw.githubusercontent.com/lewagon/setup/master", "_partials", "#{match_data[:partial]}.md"))
                .string
      else
        file = File.join("_partials", "#{partial}.md")
        content = File.read(file, encoding: "utf-8")
      end
      subs[filename].each { |pattern, replace| content.gsub!(pattern, replace) }
      f << content.gsub("<PYTHON_VERSION>", PYTHON_VERSION)
      f << "\n\n"
    end
  end
end
