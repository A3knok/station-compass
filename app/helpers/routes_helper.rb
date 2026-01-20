module RoutesHelper
  def route_description_summary(route, length: 100)
    return tag.span("詳細未設定", class: "text-muted") if route.description.blank?

    summary = truncate(strip_tags(route.description.to_s), length: length, omission: "…")
    tag.span(summary, class: "route-description")
  end

  def route_freshness_class(route)
    if route.updated_at < 6.month.ago
      "text-danger"
    elsif route.updated_at < 3.month.ago
      "text-warning"
    else
      "text-success"
    end
  end

  def route_freshness_message(route)
    if route.updated_at < 6.month.ago
      "※この情報は6ヶ月以上更新されていません"
    elsif route.updated_at < 3.month.ago
      "※この情報は3ヶ月以上更新されていません"
    else
      nil
    end
  end

  # ランキングの順位に関するメソッド
  def calculate_rank(routes)
    current_rank = 0
    previous_count = nil # 評価数の初期値
    show_rank = true

    routes.map.with_index do |route, index|
      if previous_count != route.helpful_marks_count
        current_rank = index + 1
        show_rank = true
      else
        show_rank = false
      end

      previous_count = route.helpful_marks_count

      { route: route, rank: current_rank, show_rank: show_rank }
    end
  end
end
