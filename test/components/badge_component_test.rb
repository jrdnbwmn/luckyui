# frozen_string_literal: true
require "test_helper"

class BadgeComponentTest < ViewComponent::TestCase
  def test_renders_default_badge
    render_inline(BadgeComponent.new) { "Default" }
    assert_selector "span.text-zinc-800.bg-zinc-100", text: "Default"
    assert_selector "span[role='status']"
  end

  def test_renders_with_custom_color
    render_inline(BadgeComponent.new(color: :red)) { "Red Badge" }
    assert_selector "span.text-red-800.bg-red-100", text: "Red Badge"
  end

  def test_renders_with_invalid_color_defaults_to_zinc
    render_inline(BadgeComponent.new(color: :invalid)) { "Invalid Color" }
    assert_selector "span.text-zinc-800.bg-zinc-100", text: "Invalid Color"
  end

  def test_renders_large_size
    render_inline(BadgeComponent.new(size: :large)) { "Large Badge" }
    assert_selector "span.text-sm", text: "Large Badge"
  end

  def test_renders_with_invalid_size_defaults_to_default
    render_inline(BadgeComponent.new(size: :invalid)) { "Invalid Size" }
    assert_selector "span.text-xs", text: "Invalid Size"
  end

  def test_renders_with_custom_role
    render_inline(BadgeComponent.new(role: "alert")) { "Alert Badge" }
    assert_selector "span[role='alert']", text: "Alert Badge"
  end

  def test_renders_with_aria_label
    render_inline(BadgeComponent.new(aria_label: "Custom label")) { "Labeled Badge" }
    assert_selector "span[aria-label='Custom label']", text: "Labeled Badge"
  end

  def test_renders_with_custom_classes
    render_inline(BadgeComponent.new(classes: "custom-class")) { "Custom" }
    assert_selector "span.custom-class", text: "Custom"
  end

  def test_renders_with_left_icon
    render_inline(BadgeComponent.new(icon: "star", icon_position: :left)) { "Starred" }
    assert_selector "span", text: "Starred"
    # Icon should be rendered before content
    assert_selector "span > svg + span", text: "Starred"
  end

  def test_renders_with_right_icon
    render_inline(BadgeComponent.new(icon: "star", icon_position: :right)) { "Starred" }
    assert_selector "span", text: "Starred"
    # Icon should be rendered after content
    assert_selector "span > span + svg"
  end

  def test_renders_closable_badge
    render_inline(BadgeComponent.new(closable: true)) { "Closable" }
    assert_selector "span", text: "Closable"
    assert_selector "button[type='button']"
    assert_selector "button[aria-label='Remove badge']"
    assert_selector "button svg"
  end

  def test_renders_closable_badge_with_custom_aria_label
    render_inline(BadgeComponent.new(closable: true, aria_label: "Important")) { "Important" }
    assert_selector "button[aria-label='Remove Important']"
  end

  def test_renders_closable_badge_with_turbo_stream
    render_inline(BadgeComponent.new(closable: true, close_turbo_stream: true)) { "Turbo Badge" }
    assert_selector "button[data-turbo-action='remove']"
  end

  def test_renders_with_onclick
    render_inline(BadgeComponent.new(on_click: "alert('clicked')")) { "Clickable" }
    assert_selector "span[onclick=\"alert('clicked')\"]", text: "Clickable"
  end

  # Test all supported colors
  BadgeComponent::COLORS.each do |color|
    define_method("test_renders_#{color}_color") do
      render_inline(BadgeComponent.new(color: color)) { color.to_s.capitalize }
      assert_selector "span.text-#{color}-800.bg-#{color}-100", text: color.to_s.capitalize
    end
  end

  # Test all supported sizes
  BadgeComponent::SIZES.each do |size, css_class|
    define_method("test_renders_#{size}_size") do
      render_inline(BadgeComponent.new(size: size)) { size.to_s.capitalize }
      assert_selector "span.#{css_class}", text: size.to_s.capitalize
    end
  end

  def test_accessibility_defaults
    render_inline(BadgeComponent.new) { "Accessible" }
    assert_selector "span[role='status']"
  end

  def test_closable_button_focus_styles
    render_inline(BadgeComponent.new(closable: true, color: :blue)) { "Focus Test" }
    assert_selector "button.focus\\:bg-blue-200.focus\\:outline-none"
  end

  def test_closable_button_hover_styles
    render_inline(BadgeComponent.new(closable: true, color: :green)) { "Hover Test" }
    assert_selector "button.hover\\:bg-green-200"
  end
end