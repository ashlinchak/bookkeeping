require "bookkeeping/proxy"

module Bookkeeping
  class Engine < ::Rails::Engine
    isolate_namespace Bookkeeping

    config.generators do |g|
      g.test_framework :rspec
    end

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.factory_girl dir: "spec/factories"
    end
  end
end
