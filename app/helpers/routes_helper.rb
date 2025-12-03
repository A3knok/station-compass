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
end
