# frozen_string_literal: true

# Performance optimization concern for ViewComponents
module PerformanceOptimized
  extend ActiveSupport::Concern

  included do
    # Cache frequently used class combinations
    class_attribute :_class_cache, default: {}
    
    # Memoize expensive operations
    def self.memoize(method_name)
      alias_method "#{method_name}_without_memoization", method_name
      
      define_method method_name do |*args|
        key = [method_name, args].hash
        @_memoized_values ||= {}
        @_memoized_values[key] ||= send("#{method_name}_without_memoization", *args)
      end
    end
  end

  private

  # Cache CSS class combinations to avoid repeated string operations
  def cached_classes(*class_parts)
    key = class_parts.hash
    self.class._class_cache[key] ||= class_parts.compact.join(" ").strip
  end

  # Efficient color validation with memoization
  def valid_color?(color, valid_colors)
    @_valid_colors ||= {}
    @_valid_colors[color] ||= valid_colors.include?(color.to_sym)
  end

  # Efficient size validation with memoization
  def valid_size?(size, valid_sizes)
    @_valid_sizes ||= {}
    @_valid_sizes[size] ||= valid_sizes.include?(size.to_sym) || valid_sizes.key?(size.to_sym)
  end

  # Efficient variant validation with memoization
  def valid_variant?(variant, valid_variants)
    @_valid_variants ||= {}
    @_valid_variants[variant] ||= valid_variants.include?(variant.to_sym)
  end
end