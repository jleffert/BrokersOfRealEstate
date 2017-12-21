module ApplicationHelper
  def nav_link(text, path)
    class_name = current_page?(path) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to text, path, class: 'nav-link'
    end
  end

  def alert_class(level)
      case level
          when 'notice' then "alert alert-info"
          when 'success' then "alert alert-success"
          when 'error' then "alert alert-danger"
          when 'alert' then "alert alert-danger"
      end
  end
end