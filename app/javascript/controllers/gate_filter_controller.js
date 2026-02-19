import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="gate-filter"
export default class extends Controller {
  static targets = ["station", "railwayCompany", "gate"]
  static values = {
    companiesByStation: Object,
    gatesByCompany: Object
  }

  connect() {
    this.disableSelect(this.railwayCompanyTarget)
    this.disableSelect(this.gateTarget)

    //  編集時: 駅が既に選択されている場合は絞り込み処理を実行
    if(this.stationTarget.value) {
      // 既存の鉄道会社IDを保存
      const selectedCompanyId = this.railwayCompanyTarget.value
      
      // 既存の改札IDを保存
      const selectedGateId = this.gateTarget.value

      // 鉄道会社の絞り込みを実行
      this.filterCompanies()

      // 絞り込み後、既存の鉄道会社のIDを復元
      if (selectedCompanyId) {
        this.railwayCompanyTarget.value = selectedCompanyId

        // 改札の絞り込みを実行
        this.filterGates()

        // 絞り込み実行後、既存の改札のIDを復元
        if(selectedGateId) {
          this.gateTarget.value = selectedGateId
        }
      }
    }
  }

  filterCompanies() {
    const selectedStationId = this.stationTarget.value

    // 鉄道会社と改札リセット
    this.clearOptions(this.railwayCompanyTarget)
    this.clearOptions(this.gateTarget)


    if(!selectedStationId) {
      this.disableSelect(this.railwayCompanyTarget)
      this.disableSelect(this.gateTarget)
      return
    }

    // 選択された駅に関連する鉄道会社を取得
    const companies = this.companiesByStationValue[selectedStationId] || []

    if(companies.length === 0) {
      this.disableSelect(this.gateTarget)
      return
    }
    
    // 鉄道会社のオプションを追加
    this.addOptions(this.railwayCompanyTarget,companies)
    this.enableSelect(this.railwayCompanyTarget)
    this.disableSelect(this.gateTarget)
  }

  // 鉄道会社が選択されたときの処理
  filterGates() {
    // ユーザーが選択したoptionのidを取得
    const selectedCompanyId = this.railwayCompanyTarget.value

    // 現在の改札状態オプションの状態をリセット
    this.clearOptions(this.gateTarget)

    // 鉄道会社が選択されていない場合改札を非表示
    if(!selectedCompanyId) {
      this.disableSelect(this.gateTarget)
      return
    }

    const gates = this.gatesByCompanyValue[selectedCompanyId] || []

    if(gates.length === 0) {
      this.disableSelect(this.gateTarget)
      return
    }

    // 改札表示処理
    this.addOptions(this.gateTarget,gates)
    this.enableSelect(this.gateTarget)
  }

  // option追加の処理  
  addOptions(selectElement,items) {
    items.forEach(item => {
      // <option value=item.id>id.name</option>がoptionに代入される
      const option = new Option(item.name, item.id) 
      selectElement.add(option)
    })
  }

  // 現在の改札状態オプションの状態をリセットする処理
  clearOptions(selectElement) {
    // "改札を選択してください"以外のオプションを削除する
    while (selectElement.options.length > 1) { // selectElement.optionsは配列
      selectElement.remove(1) // 削除すると要素がくり上がるため常にindex1を削除
    }
  }

  // セレクトボックスを無効化
  disableSelect(selectElement) {
    selectElement.disabled = true
  }

  // セレクトボックス有効化
  enableSelect(selectElement) {
    selectElement.disabled = false
  }
}