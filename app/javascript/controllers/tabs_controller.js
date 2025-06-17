import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ["tab", "panel"]
  static values = { 
    activeIndex: { type: Number, default: 0 },
    activeTabClass: String,
    inactiveTabClass: String,
  }

  connect() {
    console.log('Tabs controller connected')
    console.log('Tab targets:', this.tabTargets.length)
    console.log('Panel targets:', this.panelTargets.length)
    
    this.showActiveTab()
  }

  selectTab(event) {
    event.preventDefault()
    const clickedTab = event.currentTarget
    const newIndex = parseInt(clickedTab.getAttribute('data-tabs-index-param'))
    
    console.log('Clicked tab index:', newIndex)
    console.log('Current active index:', this.activeIndexValue)
    
    if (!isNaN(newIndex) && newIndex >= 0 && newIndex < this.panelTargets.length) {
      this.activeIndexValue = newIndex
      this.showActiveTab()
    } else {
      console.error('Invalid tab index:', newIndex)
    }
  }

  activeIndexValueChanged() {
    this.showActiveTab()
  }

  showActiveTab() {
    const activeClasses = (this.activeTabClassValue || '').split(' ').filter(Boolean)
    const inactiveClasses = (this.inactiveTabClassValue || '').split(' ').filter(Boolean)

    this.tabTargets.forEach((tab, index) => {
      const is_active = (index === this.activeIndexValue)

      if (is_active) {
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
}