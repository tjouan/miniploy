module Miniploy
  module DSL
    attr_accessor :app, :repository, :target, :ssh_args, :bundle_add

    def app_path
      "apps/#{app}"
    end

    def append(filepath, content)
      run "echo \"#{content}\" >> #{filepath}"
    end

    def bundle_run(cmd)
      run "cd #{app_path} && RACK_ENV=production bundle exec #{cmd}"
    end

    def rake(task)
      bundle_run "rake #{task}"
    end

    def run(cmd)
      puts ">> `#{cmd}`"
      raise RuntimeError unless ssh(cmd)
    end

    def run_path
      "#{app_path}/tmp/run"
    end

    def self.hook(*methods)
      methods.each do |method|
        eval <<-eoh
          def #{method}(&block)
            @hooks ||= {}
            if block_given?
              @hooks[:#{method}] = block
            else
              @hooks[:#{method}].call
            end
          end
        eoh
      end
    end

    hook :after_setup, :start, :stop, :after_update
  end
end
