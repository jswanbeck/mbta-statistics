module ApplicationHelper
  def get_nav_bar
    html = '<a class="nav-button" href="/home">Home</a>'
    return html.html_safe
  end
end