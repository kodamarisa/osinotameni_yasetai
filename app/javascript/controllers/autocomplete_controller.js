// app/javascript/controllers/autocomplete_controller.js
import { Controller } from "@hotwired/stimulus"
import { Autocomplete } from "stimulus-autocomplete"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.autocomplete = new Autocomplete(this.inputTarget, {
      url: this.data.get("url"),
      paramName: "q",
      minimumInputLength: 2,
      valueKey: "name"
    })
  }
}
