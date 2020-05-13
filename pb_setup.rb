# frozen_string_literal: true

require 'set'
require 'ruby-progressbar'

class ProgressBarSetup
  def initialize
    @progress_bar = ProgressBar.create(format: "\e[0;34m%t: |%B|\e[0m")
  end

  def increment
    @progress_bar.increment
  end

  def self.steps(iterations)
    @steps ||= begin
      step = iterations / 100
      steps = Set.new
      100.times do |i|
        steps.add(i * step)
      end
      steps
    end
  end
end
