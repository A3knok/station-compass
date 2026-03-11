# ホーム
crumb :root do
  link "HOME", root_path
end

# マイページ
crumb :my_page do
  link t("users.show.title"), user_path(current_user)
  parent :root
end

# アカウント編集
crumb :account_edit do
  link t("devise.registrations.edit.title"), edit_user_registration_path
  parent :my_page
end

# 駅一覧
crumb :stations do
  link t("stations.index.title"), stations_path
  parent :root
end

# 特定の駅のルート一覧
crumb :routes do |station|
  link "#{station.name}のルート", station_routes_path(station)
  parent :stations
end

# ランキングページ
crumb :ranking do |station|
  link t("ranks.index.title"), station_ranks_path(station)
  parent :routes, station
end

# ルート詳細
crumb :route do |route|
  link "#{route.gate.name}から#{route.exit.name}出口のルート", route_path(route)
  parent :routes, route.station
end

# ルート編集
crumb :edit_route do |route|
  link t("routes.edit.title"), edit_route_path(route)
  parent :route, route
end

crumb :new_route do
  link t("routes.new.title"), new_route_path
  parent :root
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
