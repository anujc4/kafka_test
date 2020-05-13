# frozen_string_literal: true

require 'waterdrop'
require 'ruby-progressbar'
require_relative 'config'

class WaterDropSetup
  def initialize
    WaterDrop.setup do |config|
      config.deliver = true
      config.kafka.seed_brokers = %w[kafka://localhost:9092]
    end
  end

  def publish(topic, iterations)
    progress_bar = ProgressBar.create(format: "\e[0;34m%t: |%B|\e[0m", title: 'Messages Published:', total: iterations)
    iterations.times do |i|
      progress_bar.increment
      WaterDrop::SyncProducer.call("WATERDROP_#{i}", topic: topic)
    end
  end
end
