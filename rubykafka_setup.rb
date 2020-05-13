# frozen_string_literal: true

require 'ruby-kafka'
require 'ruby-progressbar'
require_relative 'config'

class RubykafkaSetup
  def initialize
    kafka = Kafka.new(['kafka://localhost:9092'], client_id: CLIENT)
    @producer = kafka.producer
  end

  def publish(topic, iterations)
    progress_bar = ProgressBar.create(format: "\e[0;34m%t: |%B|\e[0m", title: 'Messages Published:', total: iterations)
    iterations.times do |i|
      progress_bar.increment
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
