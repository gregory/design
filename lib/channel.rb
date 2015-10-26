module Radio
  class Channel
    include Wisper::Publisher

    def emit(*args)
      publish(*args)
    end
  end
end

module Interactor
  module Extentions
    def self.included(base)
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def with_fail(params)
        context.fail(params)
        yield
      end

      def channels
        context.channels ||= Hash.new { |h,k| h[k] = Radio::Channel.new }
      end

      def emit(channel, *args)
        channels[channel].emit(*args)
      end
    end
  end
end

Interactor.send :include, Interactor::Extentions
