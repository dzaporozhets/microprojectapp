module ActiveSupport
  class Deprecation
    class << self
      def warn(message = nil, callstack = nil)
        instance.warn(message, callstack)
      end
    end
  end
end
