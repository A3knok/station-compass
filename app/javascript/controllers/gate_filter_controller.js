import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="gate-filter"
export default class extends Controller {
  static targets = []
  connect() {
    console.log("gate_filter_controller.jsが作成されました")
    // this.filterGates()
  }
}
