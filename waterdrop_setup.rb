# frozen_string_literal: true

require 'waterdrop'
require_relative 'config'

class WaterDropSetup
  def initialize
    WaterDrop.setup do |config|
      config.deliver = true
      config.kafka.seed_brokers = %w[kafka://localhost:9092]
    end
  end

  def publish(topic, iterations)
    iterations.times do |i|
      WaterDrop::SyncProducer.call("WATERDROP_#{i}", topic: topic)
    end
  end
end
