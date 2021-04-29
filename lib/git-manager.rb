require 'git'

class GitManager
  attr_reader :tags

  def initialize(directory = Dir.pwd)
    @git_obj = Git.open(directory)
    @tags = @git_obj.tags.collect(&:name)
  end

  def deploy_tag
    deploy_branch = ENV.fetch('DEPLOY_BRANCH') do |_val|
      filtered_tags = tags.select { |e| e.match?(/^\d+\.\d+(\.\d+)?$/) }
      filtered_tags.empty? ? nil : filtered_tags.max_by { |v| Gem::Version.new(v) }
    end

    validate!(deploy_branch)

    deploy_branch
  end

  private

  def validate!(branch)
    branch_exists!(branch)
    name_looks_right!(branch)
  end

  def branch_exists!(branch)
    return unless branch.nil?

    fail(
      <<~STRING
        There are currently no 'x.y[.z]' tags.
        Please create one and try again or set DEPLOY_BRANCH environment variable.
      STRING
    )
  end

  def name_looks_right!(branch)
    return unless ENV['DEPLOY_BRANCH'].nil? && branch.split('.')[0].length > 1

    fail(
      <<~STRING
        #{branch} looks like it has more than one digit in
        it's major version number, are you sure this is the right version
        to deploy? If so, please update the validation checks in
        lib/git_manager.rb.
      STRING
    )
  end
end
