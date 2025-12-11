module ApplicationHelper
  def page_title(title = "")
    base_title = "駅コンパス"
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def flash_bootstrap_class(message_type)
    case message_type.to_s
    when "notice", "success"
      "alert-success"
    when "alert", "danger"
      "alert-danger"
    else
      "alert-info"
    end
  end

  def route_info_card(icon_class, color_class, attribute_name, value)
    tag.div(class: "col-md-4") do
      tag.div(class: "card border-#{color_class} h-100") do
        tag.div(class: "card-body text-center") do
          # concatを使わないとtag.pしか表示されない。最後の要素だけreturnされる
          concat tag.i(class: "#{icon_class} fa-2x text-#{color_class} mb-2")
          concat tag.h6(Route.human_attribute_name(attribute_name), class: "card-title text-#{color_class}")
          concat tag.p(value, class: "card-text fw-bold")
        end
      end
    end
  end
end
