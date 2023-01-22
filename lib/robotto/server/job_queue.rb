# frozen_string_literal: true

module Robotto
  class Server
    class JobQueue
      def initialize
        @jobs = []
      end

      def count
        @jobs.count
      end

      # Insert element into ASC sorted array.
      def push(message)
        idx = @jobs.bsearch_index { |y| (y.date <=> message.date) >= 0 } || @jobs.size
        @jobs.insert(idx, message)
      end
      alias_method :<<, :push

      def pop!
        @jobs.pop
      end
    end
  end
end
