import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select'

export default class extends Controller {
  connect() {
    console.log('Slim Select initializing...', this.element)

    new SlimSelect({
      select: this.element,
      settings: {
        placeholderText: "タグを選択",
        searchPlaceholder: "タグを検索",
        searchText: "該当なし"
      }
    })

    console.log('Slim Select initialized!')
  }
}