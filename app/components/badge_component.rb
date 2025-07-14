# frozen_string_literal: true

class BadgeComponent < ViewComponent::Base
  # Supported colors and sizes
  COLORS = %i[zinc red orange amber yellow lime green emerald teal cyan sky blue indigo violet purple fuchsia pink rose].freeze
  SIZES = { default: 'text-xs', large: 'text-sm' }.freeze

  attr_reader :color, :size, :icon, :icon_position, :closable, :close_turbo_stream, :on_click, :classes, :aria_label, :role

  def initialize(
    color: :zinc,
    size: :default,
    icon: nil,
    icon_position: :left,
    closable: false,
    close_turbo_stream: false,
    on_click: nil,
    classes: nil,
    aria_label: nil,
    role: "status"
  )
    @color = COLORS.include?(color.to_sym) ? color.to_sym : :zinc
    @size = SIZES.key?(size.to_sym) ? size.to_sym : :default
    @icon = icon
    @icon_position = icon_position.to_sym == :right ? :right : :left
    @closable = closable
    @close_turbo_stream = close_turbo_stream
    @on_click = on_click
    @classes = classes
    @aria_label = aria_label
    @role = role
    
    # Development warnings for invalid parameters
    if Rails.env.development?
      warn "[BadgeComponent] Invalid color '#{color}'. Valid options: #{COLORS.join(', ')}" unless COLORS.include?(color.to_sym)
      warn "[BadgeComponent] Invalid size '#{size}'. Valid options: #{SIZES.keys.join(', ')}" unless SIZES.key?(size.to_sym)
      warn "[BadgeComponent] closable: true should include aria_label for accessibility" if closable && aria_label.blank?
    end
  end

  def badge_classes
    [
      'inline-flex items-center gap-1 font-medium whitespace-nowrap py-1 rounded-full px-2.5',
      SIZES[@size],
      text_class,
      bg_class,
      classes
    ].compact.join(' ')
  end

  def text_class
    "text-#{color}-800"
  end

  def bg_class
    "bg-#{color}-100"
  end

  private

  def icon_helper(*args, **kwargs)
    view_context.icon(*args, **kwargs)
  end
end 