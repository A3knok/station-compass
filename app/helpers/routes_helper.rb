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

  # ランクバッジの表示(PC版)
  def rank_badge_desktop(route, rank, show_rank)
    return content_tag(:span, "-", class: "text-muted") unless show_rank
    
    case rank
    when 1
      content_tag(:span, class: "rank-badge rank-1 d-none d-md-inline-block") do
        content_tag(:i, "", class: "fas fa-crown") + " 1位"
      end
    when 2
      content_tag(:span, class: "rank-badge rank-2 d-none d-md-inline-block") do
        content_tag(:i, "", class: "fas fa-medal") + " 2位"
      end
    when 3
      content_tag(:span, class: "rank-badge rank-3 d-none d-md-inline-block") do
        content_tag(:i, "", class: "fas fa-medal") + " 3位"
      end
    else
      content_tag(:span, class: "rank-number") do
        "#{rank}#{content_tag(:span, "位", class: "d-none d-md-inline")}"
      end
    end
  end

  # ランクバッジの表示(スマホ版)
  def rank_badge_mobile
    return "" unless show_rank
    
    case rank
    when 1
      content_tag(:span, class: "rank-badge-sm rank-1 d-md-none") do
        content_tag(:i, "", class: "fas fa-crown")
      end
    when 2, 3
      content_tag(:span, class: "rank-badge-sm rank-#{rank} d-md-none") do
        content_tag(:i, "", class: "fas fa-medal")
      end
    else
      ""
    end
  end
end
