# miniploy

A minimal deployment tool using ruby, ssh and git.


## Usage

Create a `config/miniploy.rb` file in your app:

    app = 'myapp'
    repository = 'repository-host.example:myapp'
    target = 'user@deploy-host.example'


Initial deployment:

    miniploy setup


Deploying updates from repository:

    miniploy update


## Complete config sample

    app = 'myapp'
    repository = 'repository-host.example:myapp'
    target = 'user@deploy-host.example'
    bundle_add = %w[unicorn]
    ssh_args = '-A'

    after_setup do
      append "#{app_path}/config/unicorn.rb", <<-eoh.gsub(/^ +/, '')
        pid '$HOME/#{pid_path}'
        listen '$HOME/#{run_path}/unicorn.sock'
      eoh
    end

    start do
      bundle_run 'unicorn -c config/unicorn.rb -D'
    end

    stop do
      run "kill -QUIT `cat #{pid_path}`"
    end

    after_update do
      run "kill -HUP `cat #{pid_path}`"
    end


    def pid_path
      "#{run_path}/unicorn.pid"
    end


## Requirements

- ruby
- git
- ssh client
- rake (development)


## Installation

You need ruby and rubygems, then install the miniploy gem:

  gem install miniploy
