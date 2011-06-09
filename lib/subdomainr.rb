require 'active_support'

require 'subdomainr/mapper'
require 'subdomainr/request'
require 'subdomainr/route'
require 'subdomainr/route_set'
require 'subdomainr/url_rewriter'

## Subdomainr - better subdomains for Rails 2 legacy apps.
#
# Dips into Rails and crafts better domain/subdomain recognition, routing
# and rewriting.
#
module Subdomainr
  class << self
    ## Returns the (first) domain.
    def domain
      domains.first
    end

    ## Sets a single domain, overriding any other domains.
    def domain=(value)
      @@domains = [value]
    end

    ## Returns the domains.
    def domains
      @@domains ||= []
    end

    ## Set all domains at once, overriding any other domains.
    def domains=(value)
      @@domains = value
    end

    ## Subdomains that shouldn't be considered actual subdomains
    def ignored_subdomains
      @@ignored_subdomains ||= ["www"]
    end

    ## Returns the number of TLDs to presume the host has.
    #
    # Used by default if no domain is recognised.
    #
    def tld_size
      @@tld_size ||= 1
    end

    ## Set the TLD size, fallen back to if no domain recognised.
    def tld_size=(value)
      @@tld_size = value
    end

    def preferred_domain
      domain
    end

    def preferred_domain=(value)
      return if preferred_domain == value

      @@domains.delete value
      @@domains.unshift value
    end

    ## Find the domain matching the current host.
    def domain_from_host(host)
      domains.detect { |domain| host == domain || host.ends_with?(".#{domain}") }
    end
  end
end
