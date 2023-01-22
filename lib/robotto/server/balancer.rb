# frozen_string_literal: true

module Robotto
  class Server
    class Balancer
      attr_reader :job_queue, :free_workers
      attr_accessor :status

      delegate :<<, to: :job_queue

      def initialize(**opts)
        @free_workers = []
        @job_queue = JobQueue.new
        @status = true
      end

      def distribute_job!
        job = job_queue.pop!

        return unless job

        worker = @free_workers.pop
        worker.notify!(job.as_json.freeze)
      end

      def spawn!
        Thread.new do
          while status
            distribute_job! if free_workers.count.positive?
          end
        end
      end

      def subscribe(worker)
        free_workers.prepend(worker)
      end

      def unsubscribe(worker)
        free_workers.delete(worker)
      end
    end
  end
end
