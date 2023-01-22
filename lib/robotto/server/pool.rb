# frozen_string_literal: true

module Robotto
  class Server
    class Pool
      attr_reader :workers, :balancer
      attr_reader :status

      delegate :<<, :queue_job, to: :balancer

      def initialize(**opts)
        @balancer = Server::Balancer.new(**opts)
        @workers = Array.new(opts[:workers_count] || 1, Server::BotWorker.new(@balancer))
        @status = true
      end

      def api=(api)
        workers.each do |worker|
          worker_api = api.dup
          Ractor.make_shareable(worker_api)
          worker.api = worker_api
        end
      end

      def spawn!
        workers.each(&:spawn!)
        balancer.spawn!
      end

      def stop!
        balancer.status = false
        workers.each { |w| w.status = false }
      end
    end
  end
end
