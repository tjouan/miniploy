module Miniploy
  class CLI
    ARGS = %w[setup update start stop]

    def self.run(args)
      d = Miniploy::Deploy.new
      action = args.shift
      d.send action if ARGS.include? action
    end
  end
end
