# frozen_string_literal: true

require 'ruby-kafka'
require_relative 'config'
require_relative 'pb_setup'

class RubykafkaSetup
  def initialize
    kafka = Kafka.new(['kafka://localhost:9092'], client_id: CLIENT)
    @producer = kafka.producer
  end

  def publish(topic, iterations)
    pbar = ProgressBarSetup.new
    steps = ProgressBarSetup.steps(iterations)

    iterations.times do |i|
      pbar.increment if steps.include?(i)
      @producer.produce("RUBY_KAFKA_#{i}", topic: topic)
      @producer.deliver_messages
    rescue Kafka::DeliveryFailed => e
      puts "Failed to publish for #{i}: #{e}"
    end
  ensure
    puts 'Shutting down ruby-kafka producer...'
    @producer.shutdown
  end
end
