module ApplicationHelper
  def get_nav_bar
    html = '<a class="nav-button" href="/home">Home</a>'
    html += '<hr><br>'
    return html.html_safe
  end
end