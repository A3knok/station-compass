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

  # ランク表示(PC版）
  def rank_badge_desktop(rank, show_rank)
    return content_tag(:span, "-", class: "text-muted") unless show_rank
    
    case rank
    when 1
      content_tag(:span, class: "rank-badge rank-1 d-none d-md-inline") do
        content_tag(:i, "", class: "fas fa-crown") + " 1位"
      end
    when 2
      content_tag(:span, class: "rank-badge rank-2 d-none d-md-inline") do
        content_tag(:i, "", class: "fas fa-medal") + " 2位"
      end
    else
      content_tag(:span, class: "rank-number d-none d-md-inline") do
        "#{rank}位"
      end
    end
  end

  # ランク表示(mobile版）
  def rank_badge_mobile(rank, show_rank)
    return content_tag(:span, "", class: "text-muted") unless show_rank
    
    case rank
    when 1
      content_tag(:span, class: "rank-badge rank-1 d-inline d-md-none") do
        content_tag(:i, "", class: "fas fa-crown")
      end
    when 2
      content_tag(:span, class: "rank-badge rank-2 d-inline d-md-none") do
        content_tag(:i, "", class: "fas fa-medal")
      end
    else
      content_tag(:span, class: "rank-number d-inline d-md-none") do
        "#{rank}"
      end
    end
  end
end
