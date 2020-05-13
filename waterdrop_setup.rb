# frozen_string_literal: true

require 'waterdrop'
require_relative 'config'
require_relative 'pb_setup'

class WaterDropSetup
  def initialize
    WaterDrop.setup do |config|
      config.deliver = true
      config.kafka.seed_brokers = %w[kafka://localhost:9092]
    end
  end

  def publish(topic, iterations)
    pbar = ProgressBarSetup.new
    steps = ProgressBarSetup.steps(iterations)

    iterations.times do |i|
      pbar.increment if steps.include?(i)
      WaterDrop::SyncProducer.call("WATERDROP_#{i}", topic: topic)
    end
  end
end
