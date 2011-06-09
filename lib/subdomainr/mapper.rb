## Integrate into Mapper.
# 
# In your routes you can use:
#   map.subdomain "subdomain" do |subdomain_map|
#     subdomain_map.connect ...
#   end
# 
# Supply:
#  * nothing or +true+ to require *any* subdomain
#  * +false+ to require *no* subdomain
#  * a +String+ to do a plain equality check
#  * a +RegExp+ to do a more complex test
# 
# #not_subdomain inverts the conditions but defaults to the requiring
# *no* subdomain. This is also aliased to #unless_subdomain for
# Subdomain-Fu compatibility.
# 
# There is also #no_subdomain which is a flat condition equivalent
# to #subdomain(false).
# 
# #domain similarly requires a particular domain, and takes either a
# +String+ or +RegExp+ argument.
# 
# #not_domain is the inverse of #domain.
# 
# All these methods will merge in any extra options allowing you to 
# do the following:
# 
#   map.subdomain /^member-.+$/, :controller => :members do |member_map|
#     member_map.edit :action => :edit
#     member_map.root :action => :show
#   end
# 
# You can then look up the member using +request.subdomain+ in your
# MembersController.
# 
# TODO: Params from domains/subdomains?
# 
module Subdomainr
  module Mapper
    def self.included(base)
      base.class_eval do
        include InstanceMethods
      end
    end

    module InstanceMethods
      [:subdomain, :not_subdomain].each do |option|
        define_method option do |*args, &block|
          options = args.extract_options!
          value = args.first
          value = true if value.nil?
        
          unless value == true || value == false || value.is_a?(String) || value.is_a?(Regexp)
            raise ArgumentError, "subdomain should be true, false, a String or a Regexp, not #{value.class.name}"
          end
        
          with_options(options.deep_merge(:conditions => {option => value}), &block)
        end
      end
      
      alias :unless_subdomain :not_subdomain
      
      def no_subdomain(options = {}, &block)
        with_options(options.deep_merge(:conditions => {:no_subdomain => true}), &block)
      end
      
      [:domain, :not_domain].each do |option|
        define_method option do |*args, &block|
          options = args.extract_options!
          value = args.first

          raise ArgumentError, "domain should be a String or Regexp, not #{value.class.name}" unless value.is_a?(String) || value.is_a?(Regexp)
        
          with_options(options.deep_merge(:conditions => {option => value}), &block)
        end
      end
    end
  end
end