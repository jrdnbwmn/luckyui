// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "alpine-turbo-drive-adapter"
import Alpine from "alpinejs"
import collapse from "@alpinejs/collapse"
Alpine.plugin(collapse)
window.Alpine = Alpine
Alpine.start()

document.addEventListener('turbo:load', function() {
  if (window.hljs && typeof window.hljs.highlightAll === 'function') {
    window.hljs.highlightAll();
  }
});

document.addEventListener('turbo:load', () => {
  window.Alpine && window.Alpine.initTree && window.Alpine.initTree(document.body)
})
