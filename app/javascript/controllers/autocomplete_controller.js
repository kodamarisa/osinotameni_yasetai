import { Controller } from "@hotwired/stimulus"
import Autocomplete from "stimulus-autocomplete"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.autocomplete = new Autocomplete(this.inputTarget, {
      // オプションをここに追加できます
    })
  }
}
