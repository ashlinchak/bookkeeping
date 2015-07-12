module Bookkeeping
  module Proxy
    def caller= context
      @caller = context
      exec_in_caller(context)
    end

    def method_missing(name, *args, &block)
      @caller.send(name, *args, &block)
    end

    def respond_to?(name, include_private = false)
      @caller.respond_to?(name) || super
    end

    def exec_in_caller(context)
      return unless context

      context.instance_variables.each do |ivar|
        value_from_caller = context.instance_variable_get(ivar)
        self.instance_variable_set(ivar, value_from_caller)
      end
    end
  end
end