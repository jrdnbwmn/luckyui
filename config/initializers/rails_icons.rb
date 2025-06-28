RailsIcons.configure do |config|

  # General defaults
  config.default_library = "tabler"
  # config.default_variant = "outline" # Set a default variant for all libraries

  # Override Tabler defaults
  config.libraries.tabler.outline.default.stroke_width = "2"
  config.libraries.tabler.default_variant = "outline" # Set a default variant for Tabler
  config.libraries.tabler.outline.default.css = "size-4"
  config.libraries.tabler.filled.default.css = "size-4"

  # config.libraries.tabler.exclude_variants = [] # Exclude specific variants
  # config.libraries.tabler.regular.default.css = "size-6"
  # config.libraries.tabler.solid.default.data = {}
  # config.libraries.tabler.outline.default.css = "size-6"
  # config.libraries.tabler.outline.default.data = {}
  
  # Logos library
  config.libraries.merge!(

    {
      custom: {
        logos: {
          # path: "app/assets/svg/icons/logos/",
          default: {
            css: "size-4"
          }
        }

      }
    }
  )
end
