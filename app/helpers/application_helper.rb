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

  def default_meta_tags
    {
      site: "駅コンパス",
      title: "大型駅構内での迷子を解消するサービス",
      reverse: true,
      description: "駅コンパスでは改札から出口までのルートを共有・検索し、駅構内での迷子状態を解消することができます。",
      keywords: "駅出口, 出口, アクセス, 渋谷",
      canonical: request.original_url,
      og: {
        title: :title,
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'), # OGP画像のパス
        site_name: :site,
        description: :description,
        locale: 'ja_JP'
      },
      twitter: {
        card: "summary_large_image",
        site: "@a3_knok_RUNTEQ",
        title: :title,
        description: :description,
        image: image_url('ogp.png')
      }
    }
  end

  def share_twitter_url(url:, text:)
    "https://twitter.com/share?url=#{CGI.escape(url)}&text=#{CGI.escape(text)}" # URLの文字列を返す
  end
end
