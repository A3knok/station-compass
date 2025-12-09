import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="gate-filter"
export default class extends Controller {
  static targets = ["railwayCompany", "gate"]
  static values = { gatesByCompany: Object }

  connect() {
    console.log("gate_filter_controller.jsが作成されました")
    console.log("Gates by company:", this.gatesByCompanyValue)
    console.log("Type:", typeof this.gatesByCompanyValue)
    console.log("Is empty?:", Object.keys(this.gatesByCompanyValue).length === 0)

    // すべての改札を表示
    this.showAllGates()
  }

  filterGates() {
    // ユーザーが選択したoptionのidを取得
    const selectedCompanyId = this.railwayCompanyTarget.value

    // 現在の改札状態オプションの状態をリセット
    this.clearGateOptions()

    // 鉄道会社が選択されていない場合すべての改札を表示する
    if(!selectedCompanyId) {
      this.showAllGates()
      return
    }

    const gates = this.gatesByCompanyValue[selectedCompanyId] || []
    // 改札表示処理
    this.addGateOptions(gates)
  }

  // 現在の改札状態オプションの状態をリセットする処理
  clearGateOptions() {
      // <select>要素そのものの取得
    const gateSelect = this.gateTarget

    // "改札を選択してください"以外のオプションを削除する
    while (gateSelect.options.length > 1) { // gateSelect.optionsは配列
      gateSelect.remove(1) // 削除すると要素がくり上がるため常にindex1を削除
    }
  }

  // すべての改札を表示
  showAllGates() {
    // gatesByCompanyValueの値だけ取り出してvalueの配列を1つにまとめて返す
    const allGates = Object.values(this.gatesByCompanyValue).flat()

    const sortedGates = allGates.sort((a, b) => {
      return a.name.localeCompare(b.name, 'ja')
    })

    this.addGateOptions(sortedGates)
  }

  addGateOptions(gates) {
    const gateSelect = this.gateTarget

    // 改札が１つもない場合の処理
    if(gates.length === 0) {
      const option = new Option("該当する改札がありません", "")
      option.disabled = true // selectタグの選択不可にする
      gateSelect.add(option)
      return
    }

    // 改札が存在する場合の処理
    // gatesに入れた[{id: xx, name: "xx"}, {id: yy, name: "yy"}]を１つずつ処理
    gates.forEach(gate => {
      // <option>要素を作成
      // new Option(text, value)
      const newOption = new Option(gate.name, gate.id)
      // <option>要素を<select>要素に追加      
      gateSelect.add(newOption)
    })
  }
}