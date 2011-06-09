require 'subdomainr'

# Inject everything into Rails
ActionController::Request.send :include, Subdomainr::Request
ActionController::Routing::Route.send :include, Subdomainr::Route
ActionController::Routing::RouteSet.send :include, Subdomainr::RouteSet
ActionController::Routing::RouteSet::Mapper.send :include, Subdomainr::Mapper
ActionController::UrlRewriter.send :include, Subdomainr::UrlRewriter
if Rails::VERSION::MAJOR >= 2 and Rails::VERSION::MINOR >= 2
  ActionController::UrlRewriter::RESERVED_OPTIONS.push :subdomain, :domain
end
