# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  COLORS = %i[red orange amber yellow lime green emerald teal cyan sky blue indigo violet purple fuchsia pink rose].freeze
  VARIANTS = %i[outline solid ghost color].freeze
  COLOR_VARIANTS = %i[solid soft].freeze
  SIZES = %i[small medium default large].freeze

  attr_reader :variant, :color, :color_variant, :size, :full_width, :disabled, :type, :classes, :icon_only, :grouped, :aria_label

  def initialize(
    variant: :outline,
    color: nil,
    color_variant: :solid,
    size: :default,
    full_width: false,
    disabled: false,
    type: "button",
    classes: nil,
    icon_only: false,
    grouped: false,
    aria_label: nil
  )
    @variant = variant.to_sym
    @color = color&.to_sym
    @color_variant = color_variant.to_sym
    @size = size.to_sym
    @full_width = full_width
    @disabled = disabled
    @type = type
    @classes = classes
    @icon_only = icon_only
    @grouped = grouped
    @aria_label = aria_label
    if Rails.env.development? && icon_only && aria_label.blank?
      warn "[ButtonComponent] icon_only: true requires aria_label for accessibility"
    end
  end

  def button_classes
    base = [
      "inline-flex items-center justify-center gap-2 font-medium rounded-lg cursor-pointer focus:outline-none whitespace-nowrap",
      (icon_only ? "h-[38px] w-[38px] px-0 py-0" : size_class),
      full_width ? "w-full" : nil,
      disabled ? "disabled:cursor-default disabled:pointer-events-none" : nil,
      variant_class,
      classes
    ].compact.join(" ")
    base.strip
  end

  def size_class
    case size
    when :small
      "text-xs rounded-md px-2 py-0.5 h-auto"
    when :medium
      "text-sm rounded-lg px-3 py-1 h-auto"
    when :large
      "px-6 py-2.5 h-auto"
    else
      "text-sm rounded-lg px-4 py-2 h-auto"
    end
  end

  def variant_class
    return color_variant_class if variant == :color && color
    case variant
    when :outline
      grouped ? "text-zinc-800 bg-white hover:bg-zinc-100 disabled:opacity-75 focus:ring-2 focus:ring-zinc-100" : "text-zinc-800 bg-white border border-zinc-300 hover:bg-zinc-100 disabled:opacity-75 focus:ring-2 focus:ring-zinc-100"
    when :solid
      grouped ? "text-zinc-50 bg-zinc-800 hover:bg-zinc-950 disabled:opacity-75 focus:ring-2 focus:ring-zinc-300" : "text-zinc-50 bg-zinc-800 border border-transparent hover:bg-zinc-950 disabled:opacity-75 focus:ring-2 focus:ring-zinc-300"
    when :ghost
      grouped ? "text-zinc-800 bg-white border-transparent hover:bg-zinc-100 hover:border-zinc-100 disabled:opacity-75" : "text-zinc-800 bg-white border border-transparent hover:bg-zinc-100 hover:border-zinc-100 disabled:opacity-75"
    else
      ""
    end
  end

  def color_variant_class
    return "" unless COLORS.include?(color)
    if color_variant == :soft
      grouped ? "text-#{color}-800 bg-#{color}-100 hover:bg-#{color}-200 disabled:opacity-75" : "text-#{color}-800 bg-#{color}-100 border border-transparent hover:bg-#{color}-200 disabled:opacity-75"
    else
      # solid
      if %i[amber yellow lime].include?(color)
        grouped ? "text-#{color}-950 bg-#{color}-400 hover:bg-#{color}-500 disabled:opacity-75" : "text-#{color}-950 bg-#{color}-400 border border-transparent hover:bg-#{color}-500 disabled:opacity-75"
      else
        grouped ? "text-#{color}-50 bg-#{color}-600 hover:bg-#{color}-700 disabled:opacity-75" : "text-#{color}-50 bg-#{color}-600 border border-transparent hover:bg-#{color}-700 disabled:opacity-75"
      end
    end
  end
end 