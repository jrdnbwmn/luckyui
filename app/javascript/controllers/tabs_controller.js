import { Controller } from "@hotwired/stimulus"

// Refactored to match excid3/tailwindcss-stimulus-components tabs controller
export default class extends Controller {
  static targets = ["tab", "panel"]
  static values = {
    activeIndex: { type: Number, default: 0 },
    activeTabClass: String,
    inactiveTabClass: String,
  }

  connect() {
    this.showActiveTab()
    this.setAriaAttributes()
  }

  selectTab(event) {
    event.preventDefault()
    const clickedTab = event.currentTarget
    const newIndex = parseInt(clickedTab.getAttribute("data-tabs-index-param"))
    if (!isNaN(newIndex) && newIndex >= 0 && newIndex < this.tabTargets.length) {
      this.activeIndexValue = newIndex
      this.showActiveTab()
      this.setAriaAttributes()
      this.tabTargets[newIndex].focus()
    }
  }

  activeIndexValueChanged() {
    this.showActiveTab()
    this.setAriaAttributes()
  }

  showActiveTab() {
    const activeClasses = (this.activeTabClassValue || '').split(' ').filter(Boolean)
    const inactiveClasses = (this.inactiveTabClassValue || '').split(' ').filter(Boolean)

    this.tabTargets.forEach((tab, index) => {
      const isActive = (index === this.activeIndexValue)
      if (isActive) {
        tab.classList.remove(...inactiveClasses)
        tab.classList.add(...activeClasses)
      } else {
        tab.classList.remove(...activeClasses)
        tab.classList.add(...inactiveClasses)
      }
    })

    this.panelTargets.forEach((panel, index) => {
      panel.hidden = (index !== this.activeIndexValue)
    })
  }

  setAriaAttributes() {
    this.tabTargets.forEach((tab, index) => {
      tab.setAttribute("role", "tab")
      tab.setAttribute("aria-selected", index === this.activeIndexValue ? "true" : "false")
      tab.setAttribute("tabindex", index === this.activeIndexValue ? "0" : "-1")
    })
    this.panelTargets.forEach((panel, index) => {
      panel.setAttribute("role", "tabpanel")
      panel.setAttribute("tabindex", "0")
      panel.setAttribute("aria-labelledby", this.tabTargets[index]?.id || null)
    })
  }

  // Keyboard navigation (Left, Right, Home, End)
  // Attach this to the tablist via data-action="keydown->tabs#onKeydown"
  onKeydown(event) {
    const { key } = event
    const count = this.tabTargets.length
    let newIndex = this.activeIndexValue
    if (key === "ArrowRight") {
      newIndex = (this.activeIndexValue + 1) % count
    } else if (key === "ArrowLeft") {
      newIndex = (this.activeIndexValue - 1 + count) % count
    } else if (key === "Home") {
      newIndex = 0
    } else if (key === "End") {
      newIndex = count - 1
    } else {
      return
    }
    event.preventDefault()
    this.activeIndexValue = newIndex
    this.showActiveTab()
    this.setAriaAttributes()
    this.tabTargets[newIndex].focus()
  }
}