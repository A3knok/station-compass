module RoutesHelper
  def route_description_summary(route, length: 100)
    return tag.span("詳細未設定", class: "text-muted") if route.description.blank?

    summary = truncate(strip_tags(route.description.to_s), length: length, omission: "…")
    tag.span(summary, class: "route-description")
  end
end
