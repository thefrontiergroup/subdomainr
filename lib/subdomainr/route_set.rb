module Subdomainr
  # Support for Subdomainr::Mapper
  module RouteSet #+nodoc+
    def self.included(base)
      base.class_eval do
        # BEWARE: alias_method_chain treads on itself when called multiple times.
        # This re-aliases the new code, but leaves the old code in place.
        unless private_instance_methods.map(&:to_sym).include? :extract_request_environment_without_subdomainr
          alias_method :extract_request_environment_without_subdomainr, :extract_request_environment
        end
        alias_method :extract_request_environment, :extract_request_environment_with_subdomainr
      end
    end

    def extract_request_environment_with_subdomainr(request)
      extract_request_environment_without_subdomainr(request).tap do |env|
        [:host, :domain, :subdomain].each do |key|
          env[key] = request.send key
        end
      end
    end
  end
end