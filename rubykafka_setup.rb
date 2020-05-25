# frozen_string_literal: true

require 'ruby-kafka'
require 'ruby-progressbar'
require_relative 'config'

class RubykafkaSetup
  def initialize
    @kafka = Kafka.new(['kafka://localhost:9092'], client_id: CLIENT)
    @producer = @kafka.producer
    @async_producer = @kafka.async_producer
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

  def publish_low_thp(topic, iterations)
    progress_bar = ProgressBar.create(format: "\e[0;34m%t: |%B|\e[0m", title: 'Messages Published:', total: iterations)
    iterations.times do |i|
      progress_bar.increment
      @kafka.deliver_message("RUBY_KAFKA_#{i}", topic: topic)
    end
  end

  def publish_async(_topic, iterations)
    iterations.times do |_i|
      @async_producer.deliver_messages
    end
  end
end
