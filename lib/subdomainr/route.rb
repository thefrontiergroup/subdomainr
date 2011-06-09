module Subdomainr
  # Support for Subdomainr::Mapper
  module Route #+nodoc+
    def self.included(base)
      base.class_eval do
        # BEWARE: alias_method_chain treads on itself when called multiple times.
        # This re-aliases the new code, but leaves the old code in place.
        unless private_instance_methods.map(&:to_sym).include? :recognition_conditions_without_subdomainr
          alias_method :recognition_conditions_without_subdomainr, :recognition_conditions
        end
        alias_method :recognition_conditions, :recognition_conditions_with_subdomainr
      end
    end

    def recognition_conditions_with_subdomainr
      recognition_conditions_without_subdomainr.tap do |clauses|
        unless conditions[:subdomain].nil?
          if conditions[:subdomain] == true
            clauses << "env[:subdomain].present?"
          elsif conditions[:subdomain] == false
            clauses << "env[:subdomain] == false"
          elsif conditions[:subdomain].is_a?(Regexp)
            clauses << "(env[:subdomain] != false && #{conditions[:subdomain].inspect}.match(env[:subdomain]))"
          elsif conditions[:subdomain].respond_to? :call
            clauses << "conditions[:subdomain].call(env[:subdomain])"
          elsif conditions[:subdomain].is_a?(String) && conditions[:subdomain].present?
            clauses << "env[:subdomain] == conditions[:subdomain]"
          end
        end
        
        unless conditions[:not_subdomain].nil?
          if conditions[:not_subdomain] == true
            clauses << "env[:subdomain] == false"
          elsif conditions[:not_subdomain] == false
            clauses << "env[:subdomain].present?"
          elsif conditions[:not_subdomain].is_a?(Regexp)
            clauses << "(env[:subdomain] == false || !#{conditions[:not_subdomain].inspect}.match(env[:subdomain]))"
          elsif conditions[:not_subdomain].respond_to? :call
            clauses << "!conditions[:not_subdomain].call(env[:subdomain])"
          elsif conditions[:not_subdomain].is_a?(String) && conditions[:not_subdomain].present?
            clauses << "env[:subdomain] != conditions[:not_subdomain]"
          end
        end
        
        unless conditions[:no_subdomain].nil?
          if conditions[:no_subdomain]
            clauses << "env[:subdomain] == false"
          elsif !conditions[:no_subdomain]
            clauses << "env[:subdomain].present?"
          end
        end
        
        unless conditions[:domain].nil?
          if conditions[:domain].is_a?(Regexp)
            clauses << "#{conditions[:domain].inspect}.match(env[:domain])"
          elsif conditions[:domain].respond_to? :call
            clauses << "conditions[:domain].call(env[:domain])"
          elsif conditions[:domain].is_a?(String) && conditions[:domain].present?
            clauses << "env[:domain] == conditions[:domain]"
          end
        end
        
        unless conditions[:not_domain].nil?
          if conditions[:not_domain].is_a?(Regexp)
            clauses << "!#{conditions[:not_domain].inspect}.match(env[:domain])"
          elsif conditions[:not_domain].respond_to? :call
            clauses << "!conditions[:not_domain].call(env[:domain])"
          elsif conditions[:not_domain].is_a?(String) && conditions[:not_domain].present?
            clauses << "env[:domain] != conditions[:not_domain]"
          end
        end
      end
    end
  end
end