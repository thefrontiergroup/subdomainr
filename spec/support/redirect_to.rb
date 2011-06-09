module Subdomainr
  module RedirectToMatcher
    def self.included(base)
      base.class_eval do
        unless protected_instance_methods.map(&:to_sym).include? :path_hash_without_subdomainr
          alias_method :path_hash_without_subdomainr, :path_hash
        end
        alias_method :path_hash, :path_hash_with_subdomainr
      end
    end

    protected
    
    def path_hash_with_subdomainr(url)
      path = url.sub(/^\w+:\/\/#{@request.host}(?::\d+)?/, "").split("?", 2)[0]
      ::ActionController::Routing::Routes.recognize_path path, { :method => :get, :host => @request.host, :subdomain => @request.subdomain, :domain => @request.domain }
    end
  end
end

if defined? Remarkable::ActionController::Matchers::RedirectToMatcher
  Remarkable::ActionController::Matchers::RedirectToMatcher.send :include, Subdomainr::RedirectToMatcher
end

if defined? Spec::Rails::Matchers::RedirectTo
  Spec::Rails::Matchers::RedirectTo.send :include, Subdomainr::RedirectToMatcher
end