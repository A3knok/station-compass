import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="gate-filter"
export default class extends Controller {
  static targets = ["railwayCompany", "gate"]
  static values = { gatesByCompany: Object }

  connect() {
    console.log("gate_filter_controller.jsが作成されました")

    this.showAllGates()
  }
}
