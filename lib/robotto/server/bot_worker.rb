# frozen_string_literal: true

module Robotto
  class Server
    class BotWorker
      attr_reader :balancer, :id
      attr_accessor :api, :status

      delegate :<<, :queue_job, to: :balancer

      class << self
        def worker_id_seq!
          return @worker_id_seq += 1 if @worker_id_seq

          @worker_id_seq = 0
        end
      end

      def initialize(balancer)
        @id = Server::BotWorker.worker_id_seq!
        @balancer = balancer
        @status = true

        super()

        balancer.subscribe(self)
      end

      def job_finished!
        balancer.subscribe(self)
      end

      def job_started!
        balancer.unsubscribe(self)
      end

      def notify!(message)
        @ractor.send(message)
      end


      def spawn!
        @ractor =
          Ractor.new(self) do |worker|
            processor = Processor::Base.new
            while worker.status && (message = receive)
              processor.process_message(Telegram::Bot::Types::Message.new(message))
              job_started!
              begin
                worker.api.send_message(chat_id: message['from']['chat_id'], text: 'test')
                # worker.process_job!(message)
              rescue StandardError => e
                puts e.message
                puts e.backtrace
              ensure
                worker.job_finished!
              end
            end
            puts "Worker ID=#{id} stopped!".bold.yellow
          end
      end
    end
  end
end
