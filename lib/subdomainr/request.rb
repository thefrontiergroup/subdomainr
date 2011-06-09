module Subdomainr
  module Request #+nodoc+
    # Modifies ActionController::Request adding domain/subdomain handling.

    def self.included(base)
      base.class_eval do
        include InstanceMethods

        # BEWARE: alias_method_chain treads on itself when called multiple times.
        # This re-aliases the new code, but leaves the old code in place.
        unless instance_methods.map(&:to_sym).include? :domain_without_subdomainr
          alias_method :domain_without_subdomainr, :domain
        end
        alias_method :domain, :domain_with_subdomainr
      end
    end

    module InstanceMethods
      ## Current subdomain
      #
      # ActionPack only provides an Array subdomains, we provide a string subdomain.
      #
      # @returns String subdomain portion of current host
      #
      def subdomain
        @_subdomain ||= begin
          return false if host == domain or host == ".#{domain}"

          # Slice the subdomain off the host
          subdomain = host.first(host.size - domain.size - 1)

          return false if Subdomainr.ignored_subdomains.include? subdomain

          # I miss #presence
          subdomain.present? ? subdomain : false
        end
      end

      ## Current domain
      #
      # ActionPack will return the tld + segment by default and must be
      # explicitly overridden in each call to #domain using tld_sizes.
      #
      # We provide a global tld size configuration option, plus allow
      # adding explicit domains on a first-matched basis.
      #
      # @see Subdomainr.tld_size, Subdomainr.domains
      #
      # @params Number tld_size by-pass Subdomainr behaviour, using
      #   traditional #domain(tld_size).
      #
      # @returns String subdomain portion of current host
      #
      def domain_with_subdomainr(tld_size=nil)
        return domain_without_subdomainr(tld_size) unless tld_size.nil?

        @_domain ||= Subdomainr.domain_from_host(host) || domain_without_subdomainr(Subdomainr.tld_size)
      end
    end
  end
end
