module Subdomainr
  module UrlRewriter #+nodoc+
    # Modifies UrlRewriter to take :subdomain options during rewrite.

    def self.included(base)
      base.class_eval do
        # BEWARE: alias_method_chain treads on itself when called multiple times.
        # This re-aliases the new code, but leaves the old code in place.
        unless instance_methods.map(&:to_sym).include? :rewrite_without_subdomainr
          alias_method :rewrite_without_subdomainr, :rewrite
        end
        alias_method :rewrite, :rewrite_with_subdomainr
      end
    end

    # XXX: Rewrite paths into URLs (adding host) if :subdomain or :domain provided and not current?
    # XXX: What if they specify :host? How to extract domain without using ActionController::Request...
    def rewrite_with_subdomainr(options)
      if options.kind_of?(Hash) && !options[:only_path] && (options.has_key?(:subdomain) || options.has_key?(:domain))
        # Use :subdomain => false to have no subdomain, otherwise default to request subdomain.
        subdomain = options.delete(:subdomain)
        subdomain ||= @request.subdomain unless subdomain == false
        domain = options.delete(:domain) || @request.domain
        options[:host] = if subdomain.present?
          "#{subdomain}.#{domain}"
        else
          domain
        end
      end
    
      rewrite_without_subdomainr(options)
    end

    # XXX: Shoud url_for helpers check subdomain conditions?
  end
end