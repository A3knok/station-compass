module ApplicationHelper
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
end
