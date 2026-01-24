import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select'

export default class extends Controller {
  connect() {
    console.log('Slim Select initializing...', this.element)

    if (this.slimSelect) {
      console.log('Already initialized')
      return
    }

    // slim-select v2の初期化方法
    this.slimSelect = new SlimSelect({
      select: this.element,
      placeholder: "タグを選択",
      searchPlaceholder: "タグを検索",
      searchText: "該当なし",
      allowDeselect: true,
      hideSelectedOption: true, // 追加: 選択済みオプションを隠す
    })

    // 初期化後に元のselectタグを強制的に非表示
    this.element.style.display = 'none'
    this.element.style.visibility = 'hidden'

    console.log('Slim Select initialized!')
  }

  disconnect() {
    if (this.slimSelect) {
      this.slimSelect.destroy()
      this.slimSelect = null
    }
  }
}