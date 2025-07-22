# frozen_string_literal: true

class TabComponent < ViewComponent::Base
  VARIANTS = %i[line pill segmented].freeze
  ORIENTATIONS = %i[horizontal vertical].freeze
  CONTENT_PANEL_VARIANTS = %i[bordered minimal none full].freeze

  renders_many :tab_contents, TabContentComponent

  attr_reader :variant, :orientation, :tabs, :component_id, :heading, :sections, :content_panel_variant, :content_panel_classes

  def initialize(
    variant: :line,
    orientation: :horizontal,
    tabs: [],
    component_id: nil,
    heading: nil,
    sections: nil,
    content_panel_variant: :minimal,
    content_panel_classes: nil
  )
    @variant = VARIANTS.include?(variant.to_sym) ? variant.to_sym : :line
    @orientation = ORIENTATIONS.include?(orientation.to_sym) ? orientation.to_sym : :horizontal
    @tabs = tabs || []
    @sections = sections
    @component_id = component_id || "tabs-#{SecureRandom.hex(4)}"
    @heading = heading
    @content_panel_variant = CONTENT_PANEL_VARIANTS.include?(content_panel_variant.to_sym) ? content_panel_variant.to_sym : :minimal
    @content_panel_classes = content_panel_classes

    # Development warnings for accessibility and invalid parameters
    if Rails.env.development?
      warn "[TabComponent] Invalid variant '#{variant}'. Valid options: #{VARIANTS.join(', ')}" unless VARIANTS.include?(variant.to_sym)
      warn "[TabComponent] Invalid orientation '#{orientation}'. Valid options: #{ORIENTATIONS.join(', ')}" unless ORIENTATIONS.include?(orientation.to_sym)
      warn "[TabComponent] Invalid content_panel_variant '#{content_panel_variant}'. Valid options: #{CONTENT_PANEL_VARIANTS.join(', ')}" unless CONTENT_PANEL_VARIANTS.include?(content_panel_variant.to_sym)
      warn "[TabComponent] No tabs or sections provided" if tabs.empty? && (sections.nil? || sections.empty?)
    end
  end

  def wrapper_classes
    base = [ "w-full" ]
    base << "mx-auto max-w-lg" if orientation == :vertical
    base.compact.join(" ")
  end

  def container_classes
    base = []
    if orientation == :vertical && has_content_tabs?
      base << "flex gap-6"
    elsif orientation == :horizontal
      base << "flex flex-wrap items-center justify-center gap-3"
    end
    base.compact.join(" ")
  end

  def tabs_wrapper_classes
    case variant
    when :line
      if orientation == :vertical
        "flex flex-col w-56 gap-4"
      else
        "border-b border-b-zinc-200"
      end
    when :pill
      if orientation == :vertical
        "flex flex-col gap-3"
      else
        ""
      end
    when :segmented
      if orientation == :vertical
        "flex flex-col gap-2"
      else
        ""
      end
    end
  end

  def tabs_list_classes
    base = [ "text-sm font-medium" ]

    case variant
    when :line
      if orientation == :vertical
        base << "text-zinc-500 flex flex-col gap-2 border-l-2 border-zinc-200"
      else
        base << "-mb-px flex items-center gap-4 text-zinc-500"
      end
    when :pill
      if orientation == :vertical
        base << "flex flex-col gap-1 w-56"
      else
        base << "flex items-center gap-2"
      end
    when :segmented
      if orientation == :vertical
        base << "flex flex-col gap-1.5 w-56"
      else
        base << "flex items-center gap-1.5"
      end
    end

    base.compact.join(" ")
  end

  def segmented_background_classes
    "rounded-xl bg-zinc-100 p-1.5"
  end

  def tab_item_classes(index)
    base = [ "inline-flex cursor-pointer items-center gap-2" ]

    case variant
    when :line
      if orientation == :vertical
        base << "w-full border-l-2 border-transparent px-4 text-sm hover:text-zinc-900 min-h-[23px]"
      else
        base << "px-1.5 py-3 hover:text-zinc-900"
      end
    when :pill
      if orientation == :vertical
        base << "w-full rounded-lg px-3 py-1.5 border border-transparent text-zinc-500 hover:text-zinc-900"
      else
        base << "rounded-lg px-3 py-1.5 border border-transparent text-zinc-500 hover:text-zinc-900"
      end
    when :segmented
      if orientation == :vertical
        base << "w-full rounded-lg px-3 py-1.5 border border-transparent text-zinc-600 hover:bg-white hover:text-zinc-900 hover:shadow"
      else
        base << "rounded-lg px-3 py-1.5 border border-transparent text-zinc-600 hover:bg-white hover:text-zinc-900 hover:shadow"
      end
    end

    base.compact.join(" ")
  end

  def dropdown_button_classes
    case variant
    when :line
      if orientation == :vertical
        "inline-flex w-full cursor-pointer items-center gap-2 border-l-2 border-transparent px-4 font-medium text-sm hover:text-zinc-900 text-zinc-500"
      else
        "inline-flex cursor-pointer items-center gap-2 px-1.5 py-3 hover:text-zinc-900"
      end
    when :pill
      if orientation == :vertical
        "inline-flex w-full cursor-pointer items-center gap-2 rounded-lg px-3 py-1.5 border border-transparent text-zinc-500 hover:text-zinc-900"
      else
        "inline-flex cursor-pointer items-center gap-2 rounded-lg px-3 py-1.5 border border-transparent text-zinc-500 hover:text-zinc-900"
      end
    when :segmented
      if orientation == :vertical
        "inline-flex w-full cursor-pointer items-center gap-2 rounded-lg px-3 py-1.5 border border-transparent text-zinc-600 hover:bg-white hover:text-zinc-900 hover:shadow"
      else
        "inline-flex cursor-pointer items-center gap-2 rounded-lg px-3 py-1.5 border border-transparent text-zinc-600 hover:bg-white hover:text-zinc-900 hover:shadow"
      end
    end
  end

  def dropdown_item_classes
    case variant
    when :line
      if orientation == :vertical
        "inline-flex cursor-pointer items-center gap-2 w-full border-l-2 border-transparent pl-10 pr-4 font-medium text-sm hover:text-zinc-900 min-h-[23px]"
      else
        "px-2 py-1.5 w-full flex items-center rounded-md transition-colors text-left text-zinc-800 hover:bg-zinc-100 focus-visible:bg-zinc-100 cursor-pointer"
      end
    when :pill
      if orientation == :vertical
        "inline-flex w-full cursor-pointer items-center gap-2 rounded-lg px-3 py-1.5 border border-transparent text-zinc-500 hover:text-zinc-900 text-sm"
      else
        "px-2 py-1.5 w-full flex items-center rounded-md transition-colors text-left text-zinc-800 hover:bg-zinc-100 focus-visible:bg-zinc-100 cursor-pointer"
      end
    when :segmented
      if orientation == :vertical
        "flex cursor-pointer items-center gap-2 rounded-lg ml-6 px-3 py-1.5 border border-transparent text-zinc-600 hover:bg-white hover:text-zinc-900 hover:shadow text-sm"
      else
        "px-2 py-1.5 w-full flex items-center rounded-md transition-colors text-left text-zinc-800 hover:bg-zinc-100 focus-visible:bg-zinc-100 cursor-pointer"
      end
    end
  end

  def content_panel_classes
    # Return custom classes if provided
    return @content_panel_classes if @content_panel_classes.present?

    # Return no classes for 'none' variant
    return "" if content_panel_variant == :none

    base = []

    # Base layout classes
    if orientation == :vertical
      base << "flex-1"

      # Add spacing based on content panel variant
      case content_panel_variant
      when :bordered
        base << "pt-3 border border-zinc-200 rounded-lg p-4"
      when :minimal
        base << "pt-3 pl-6"
      when :full
        base << "pt-3"
      end
    else
      # Horizontal orientation spacing
      case variant
      when :line
        base << (content_panel_variant == :none ? "" : "py-3")
      when :pill
        base << (content_panel_variant == :none ? "" : "pt-4")
      when :segmented
        base << (content_panel_variant == :none ? "" : "py-3")
      end
    end

    base.compact.join(" ")
  end

  def keyboard_navigation_keys
    if orientation == :vertical
      {
        up: "arrow-up",
        down: "arrow-down"
      }
    else
      {
        left: "arrow-left",
        right: "arrow-right"
      }
    end
  end

  def using_sections?
    sections.present? && sections.any?
  end

  def all_tabs
    return tabs unless using_sections?
    sections.flat_map { |section| section[:tabs] || [] }
  end

  def total_tab_count
    count = 0
    all_tabs.each do |tab|
      count += 1
      if tab[:dropdown]
        count += tab[:dropdown].length
      end
    end
    count - 1 # Zero-based index
  end

  def is_navigation_tab?(tab)
    tab[:path].present?
  end

  def is_navigation_dropdown_item?(item)
    item[:path].present?
  end

  def has_mixed_navigation?
    all_tabs.any? { |tab| is_navigation_tab?(tab) } ||
    all_tabs.any? { |tab| tab[:dropdown]&.any? { |item| is_navigation_dropdown_item?(item) } }
  end

  def has_content_tabs?
    return false if all_tabs.empty?

    # Only check for block-based content - this is the only way to have content now
    has_block_content?
  end

  def render_tab_content(tab_or_item)
    # Find and render the block-based content for this tab
    block_content = find_tab_content_block(tab_or_item[:text])

    if block_content
      block_content.to_s.html_safe
    else
      # No content block provided - this shouldn't happen in normal usage
      ""
    end
  end

  def find_tab_content_block(tab_name)
    tab_contents.find { |content| content.name == tab_name }
  end

  def has_block_content?
    tab_contents.any?
  end
end
