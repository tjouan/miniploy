module Miniploy
  class Deploy
    include Miniploy::DSL

    def initialize(filepath = 'config/miniploy.rb')
      instance_eval File.read(filepath) + <<-eoh
        local_variables.each do |v|
          self.send "\#{v}=", eval(v.to_s) rescue nil
        end
      eoh
    end

    def setup
      run "git clone --depth 1 #{repository} #{app_path}"
      run "mkdir -p #{app_path}/tmp/run"
      setup_bundler
      rake 'db:create'
      rake 'db:migrate'
      after_setup
    end

    def setup_bundler
      return unless use_bundler?
      bundle_add.each do |gem|
        append "#{app_path}/Gemfile", "gem 'unicorn'"
      end
      run <<-eoh.gsub(/\A +/, '').chomp
        bundle install --without development test \\
          --gemfile #{app_path}/Gemfile --path $HOME/.bundle
      eoh
    end

    def ssh(cmd)
      system('ssh', ssh_args, target, cmd)
    end

    def update
      run "cd #{app_path} && git fetch origin && git reset --hard origin"
      setup_bundler
      rake 'db:migrate'
      after_update
    end

    def use_bundler?
      ssh "test -f #{app_path}/Gemfile"
    end
  end
end
