# frozen_string_literal: true

class TabContentComponent < ViewComponent::Base
  attr_reader :name

  def initialize(name:)
    @name = name
  end
end
