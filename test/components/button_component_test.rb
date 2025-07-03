# frozen_string_literal: true
require "test_helper"

class ButtonComponentTest < ViewComponent::TestCase
  def test_renders_default_outline
    render_inline(ButtonComponent.new) { "Outline" }
    assert_selector "button.text-zinc-800.bg-white.border-zinc-300", text: "Outline"
  end

  def test_renders_solid
    render_inline(ButtonComponent.new(variant: :solid)) { "Solid" }
    assert_selector "button.text-zinc-50.bg-zinc-800", text: "Solid"
  end

  def test_renders_ghost
    render_inline(ButtonComponent.new(variant: :ghost)) { "Ghost" }
    assert_selector "button.text-zinc-800.bg-white.border-transparent", text: "Ghost"
  end

  def test_renders_color_solid
    render_inline(ButtonComponent.new(variant: :color, color: :red, color_variant: :solid)) { "Red" }
    assert_selector "button.bg-red-600", text: "Red"
  end

  def test_renders_color_soft
    render_inline(ButtonComponent.new(variant: :color, color: :red, color_variant: :soft)) { "Red" }
    assert_selector "button.bg-red-100", text: "Red"
  end

  ButtonComponent::COLORS.each do |color|
    define_method("test_renders_#{color}_solid") do
      render_inline(ButtonComponent.new(variant: :color, color: color, color_variant: :solid)) { color.to_s.capitalize }
      assert_selector "button.bg-#{color}-600", text: color.to_s.capitalize
    end
    define_method("test_renders_#{color}_soft") do
      render_inline(ButtonComponent.new(variant: :color, color: color, color_variant: :soft)) { color.to_s.capitalize }
      assert_selector "button.bg-#{color}-100", text: color.to_s.capitalize
    end
  end

  def test_renders_small_size
    render_inline(ButtonComponent.new(size: :small)) { "Small" }
    assert_selector "button.text-xs", text: "Small"
  end

  def test_renders_medium_size
    render_inline(ButtonComponent.new(size: :medium)) { "Medium" }
    assert_selector "button.text-sm.px-3.py-1", text: "Medium"
  end

  def test_renders_large_size
    render_inline(ButtonComponent.new(size: :large)) { "Large" }
    assert_selector "button", text: "Large", class: ["px-6", "py-2.5"]
  end

  def test_renders_full_width
    render_inline(ButtonComponent.new(full_width: true)) { "Full width" }
    assert_selector "button.w-full", text: "Full width"
  end

  def test_renders_icon_left
    render_inline(ButtonComponent.new) { safe_join([icon("download", class: "size-4 -ms-1"), "Export"]) }
    assert_selector "svg.size-4.-ms-1"
    assert_selector "button", text: "Export"
  end

  def test_renders_icon_right
    render_inline(ButtonComponent.new) { safe_join(["Visit", icon("arrow-up-right", class: "size-4 -me-1")]) }
    assert_selector "svg.size-4.-me-1"
    assert_selector "button", text: "Visit"
  end

  def test_renders_icon_only
    render_inline(ButtonComponent.new) { icon("copy", class: "size-4") }
    assert_selector "button > svg.size-4", count: 1
  end

  def test_renders_icon_left_and_right
    render_inline(ButtonComponent.new) { safe_join([icon("mail", class: "size-4 -me-1"), "Email", icon("arrow-right", class: "size-4 -me-1")]) }
    assert_selector "svg.size-4.-me-1", count: 2
    assert_selector "button", text: "Email"
  end

  def test_renders_disabled
    render_inline(ButtonComponent.new(disabled: true)) { "Disabled" }
    assert_selector "button[disabled]", text: "Disabled"
  end

  def test_renders_custom_classes
    render_inline(ButtonComponent.new(classes: "custom-class")) { "Custom" }
    assert_selector "button.custom-class", text: "Custom"
  end
end 