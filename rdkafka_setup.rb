# frozen_string_literal: true

require 'rdkafka'
require 'ruby-progressbar'
require_relative 'config'

class RdkafkaSetup
  def initialize
    config = { "bootstrap.servers": 'localhost:9092' }
    @producer = Rdkafka::Config.new(config).producer
  end

  def publish(topic, iterations)
    progress_bar = ProgressBar.create(format: "\e[0;34m%t: |%B|\e[0m", title: 'Messages Published:', total: iterations)
    iterations.times do |i|
      progress_bar.increment
      @producer.produce(topic: topic, payload: "RDKAFKA_#{i}", key: i.to_s).wait
    end
  end
end
