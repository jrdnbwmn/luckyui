# frozen_string_literal: true

require 'set'

# TabComponent provides a flexible tabbed interface with URL hash integration.
# 
# Features:
# - Bookmarkable tabs via URL hash (e.g., #profile-tab)
# - Browser back/forward button support
# - Three variants: line, pill, segmented
# - Horizontal and vertical orientations
# - Sections for grouping tabs
# - Dropdown support within tabs
# - Navigation links mixed with content tabs
# - Keyboard navigation (arrow keys, home, end)
# - Full ARIA implementation for screen readers and assistive technology
#
# URL Hash Integration:
# - Tab names are automatically converted to URL-friendly hashes (e.g., #profile)
# - Users can bookmark specific tabs and share direct links  
# - Browser history is preserved for back/forward navigation
# - First occurrence of any tab name gets clean URL (#profile), duplicates get numbered (#profile-2, #profile-3)
# - Use scoped_hash: true for component-scoped hashes if preferred
class TabComponent < ViewComponent::Base
  VARIANTS = %i[line pill segmented].freeze
  ORIENTATIONS = %i[horizontal vertical].freeze

  # Global registry to track used hashes across all component instances
  # This prevents conflicts when multiple components have tabs with same names
  @@used_hashes = Set.new
  @@component_hashes = {}
  @@base_name_counts = Hash.new(0)

  renders_many :tab_contents, TabContentComponent

  attr_reader :variant, :orientation, :tabs, :component_id, :heading, :sections, :scoped_hash

  # Class method to clear the global hash registry (useful for tests and development)
  def self.reset_hash_registry!
    @@used_hashes.clear
    @@component_hashes.clear
    @@base_name_counts.clear
  end

  def initialize(
    variant: :line,
    orientation: :horizontal,
    tabs: [],
    component_id: nil,
    heading: nil,
    sections: nil,
    scoped_hash: false
  )
    @variant = VARIANTS.include?(variant.to_sym) ? variant.to_sym : :line
    @orientation = ORIENTATIONS.include?(orientation.to_sym) ? orientation.to_sym : :horizontal
    @tabs = tabs || []
    @sections = sections
    @component_id = component_id || "tabs-#{SecureRandom.hex(4)}"
    @heading = heading
    @scoped_hash = scoped_hash

    # Development warnings for accessibility and invalid parameters
    if Rails.env.development?
      warn "[TabComponent] Invalid variant '#{variant}'. Valid options: #{VARIANTS.join(', ')}" unless VARIANTS.include?(variant.to_sym)
      warn "[TabComponent] Invalid orientation '#{orientation}'. Valid options: #{ORIENTATIONS.join(', ')}" unless ORIENTATIONS.include?(orientation.to_sym)
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
    base = []

    # Base layout classes
    if orientation == :vertical
      base << "flex-1 pt-3 pl-6"
    else
      # Horizontal orientation spacing
      case variant
      when :line
        base << "py-3"
      when :pill
        base << "pt-4"
      when :segmented
        base << "py-3"
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

  def tab_id_from_name(name)
    clean_name = name.to_s.downcase.gsub(/[^a-z0-9]+/, '-').gsub(/-+/, '-').gsub(/^-+|-+$/, '')
    
    if scoped_hash
      return "#{component_id}-#{clean_name}"
    end
    
    # Check if this component already has a hash for this tab name
    component_key = "#{component_id}-#{clean_name}"
    return @@component_hashes[component_key] if @@component_hashes[component_key]
    
    # Increment count for this base name
    @@base_name_counts[clean_name] += 1
    current_count = @@base_name_counts[clean_name]
    
    # First occurrence gets clean name, subsequent get suffixes
    unique_hash = current_count == 1 ? clean_name : "#{clean_name}-#{current_count}"
    
    # Register the hash
    @@used_hashes.add(unique_hash)
    @@component_hashes[component_key] = unique_hash
    
    unique_hash
  end

  # Generate unique tab ID for ARIA attributes
  def tab_element_id(name, index = nil)
    suffix = index ? "-#{index}" : ""
    clean_name = name.to_s.downcase.gsub(/[^a-z0-9]+/, '-').gsub(/-+/, '-').gsub(/^-+|-+$/, '')
    "#{component_id}-tab-#{clean_name}#{suffix}"
  end

  # Generate unique panel ID for ARIA attributes  
  def panel_element_id(name, index = nil)
    suffix = index ? "-#{index}" : ""
    clean_name = name.to_s.downcase.gsub(/[^a-z0-9]+/, '-').gsub(/-+/, '-').gsub(/^-+|-+$/, '')
    "#{component_id}-panel-#{clean_name}#{suffix}"
  end

  def tab_names_for_hash_map
    tab_names = []
    
    if using_sections?
      sections.each_with_index do |section, section_index|
        (section[:tabs] || []).each_with_index do |tab, tab_index|
          current_tab_index = section_index * 10 + tab_index
          if tab[:dropdown]
            (tab[:dropdown] || []).each_with_index do |dropdown_item, dropdown_index|
              dropdown_tab_index = current_tab_index + dropdown_index + 100
              unless is_navigation_dropdown_item?(dropdown_item)
                tab_names << { index: dropdown_tab_index, name: dropdown_item[:text] }
              end
            end
          else
            unless is_navigation_tab?(tab)
              tab_names << { index: current_tab_index, name: tab[:text] }
            end
          end
        end
      end
    else
      tab_index = 0
      tabs.each do |tab|
        if tab[:dropdown]
          tab[:dropdown].each do |dropdown_item|
            tab_index += 1
            unless is_navigation_dropdown_item?(dropdown_item)
              tab_names << { index: tab_index, name: dropdown_item[:text] }
            end
          end
        else
          unless is_navigation_tab?(tab)
            tab_names << { index: tab_index, name: tab[:text] }
          end
          tab_index += 1
        end
      end
    end
    
    tab_names
  end

  def initial_active_tab_js
    tab_names = tab_names_for_hash_map
    hash_map = tab_names.map { |tab| "        '#{tab_id_from_name(tab[:name])}': #{tab[:index]}" }.join(",\n")
    
    <<~JS
      // Initialize active tab from URL hash or default to 0
      const hashToIndexMap = {
#{hash_map}
      };
      const hash = window.location.hash.slice(1);
      const initialIndex = hashToIndexMap[hash] !== undefined ? hashToIndexMap[hash] : 0;
      return initialIndex;
    JS
  end
end
