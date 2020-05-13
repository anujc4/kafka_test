# frozen_string_literal: true

require 'rdkafka'
require_relative 'config'
require_relative 'pb_setup'

class RdkafkaSetup
  def initialize
    config = { "bootstrap.servers": 'localhost:9092' }
    @producer = Rdkafka::Config.new(config).producer
  end

  def publish(topic, iterations)
    pbar = ProgressBarSetup.new
    steps = ProgressBarSetup.steps(iterations)

    iterations.times do |i|
      pbar.increment if steps.include?(i)
      @producer.produce(topic: topic, payload: "RDKAFKA_#{i}", key: i.to_s).wait
    end
  end
end
