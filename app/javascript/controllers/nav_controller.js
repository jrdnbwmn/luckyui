import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "lineTop", "lineBottom"]

  initialize() {
    this.transitioning = false
    this.handleResize = this.handleResize.bind(this)
  }

  connect() {
    this.handleResize()
    window.addEventListener("resize", this.handleResize)
  }

  disconnect() {
    window.removeEventListener("resize", this.handleResize)
  }

  // A getter to check the menu's visibility state from the DOM.
  get isMenuOpen() {
    return !this.menuTarget.classList.contains("hidden")
  }

  // A getter to check the hamburger icon's state.
  get isMobileMenuToggled() {
    return this.lineTopTarget.classList.contains("rotate-45")
  }

  handleResize() {
    const isDesktop = window.innerWidth >= 1024

    if (isDesktop) {
      // On desktop, the menu is controlled by Tailwind's `lg:block`, so ensure it's not hidden.
      this.menuTarget.classList.remove("hidden")
      // If the mobile menu was open, reset the hamburger icon to its default state.
      if (this.isMobileMenuToggled) {
        this.toggleHamburgerIcon()
      }
    } else {
      // On mobile, hide the menu unless it has been explicitly toggled open.
      if (!this.isMobileMenuToggled) {
        this.menuTarget.classList.add("hidden")
      }
    }
  }

  toggle(event) {
    if (event) event.stopPropagation()
    if (this.transitioning) return

    this.toggleHamburgerIcon()

    if (this.isMenuOpen) {
      this.leave()
    } else {
      this.enter()
    }
  }

  close() {
    // Closes the menu if it's open by calling the main toggle logic.
    if (this.isMenuOpen) {
      this.toggle()
    }
  }

  enter() {
    this.transitioning = true
    this.menuTarget.classList.remove("hidden")

    // Set the initial state for the transition.
    this.menuTarget.classList.add("opacity-0", "translate-y-[-10px]")

    // In the next frame, apply the transition and the final state.
    requestAnimationFrame(() => {
      this.menuTarget.classList.add("transition", "duration-200", "ease-out")
      this.menuTarget.classList.remove("opacity-0", "translate-y-[-10px]")
    })

    // After the transition, remove the transition classes and unlock.
    setTimeout(() => {
      this.menuTarget.classList.remove("transition", "duration-200", "ease-out")
      this.transitioning = false
    }, 200)
  }

  leave() {
    this.transitioning = true

    // Apply the transition and the final state classes.
    this.menuTarget.classList.add("transition", "duration-150", "ease-in", "opacity-0", "translate-y-[-10px]")

    // After the transition, hide the element and clean up classes.
    setTimeout(() => {
      this.menuTarget.classList.add("hidden")
      this.menuTarget.classList.remove("transition", "duration-150", "ease-in", "opacity-0", "translate-y-[-10px]")
      this.transitioning = false
    }, 150)
  }

  toggleHamburgerIcon() {
    this.lineTopTarget.classList.toggle("rotate-45")
    this.lineTopTarget.classList.toggle("translate-y-1")
    this.lineBottomTarget.classList.toggle("-rotate-45")
    this.lineBottomTarget.classList.toggle("-translate-y-1")
  }
} 