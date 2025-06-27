# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "alpinejs" # @3.14.9
pin "@alpinejs/collapse", to: "@alpinejs--collapse.js" # @3.14.9
pin "alpine-turbo-drive-adapter", to: "alpine-turbo-drive-adapter.min.js" # @2.2.0
pin "@ryangjchandler/alpine-tooltip", to: "@ryangjchandler--alpine-tooltip.js" # @2.0.1
pin "tippy.js" # @6.3.7
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
