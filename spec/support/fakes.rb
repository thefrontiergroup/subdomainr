class FakeRequest
  def initialize(attrs = {})
    attrs.reverse_merge! :host => 'subdomain.domain', :domain => 'domain'
    attrs.each { |key, value| instance_variable_set "@#{key}", value }
  end
  
  attr :host
  
  def domain(tld_size=1)
    @domain
  end
  
  include Subdomainr::Request
end

class FakeRoute
  def initialize(conditions = {})
    @conditions = conditions.reverse_merge :default => true
  end
  
  attr :conditions
  
  def recognition_conditions
    ['conditions[:default]']
  end
  
  def recognize(env)
    eval recognition_conditions.join '&&'
  end
  
  include Subdomainr::Route
end

class FakeRouteSet
  def extract_request_environment(request)
    {:original => 'environment'}
  end

  include Subdomainr::RouteSet
end

class FakeMapper
  def with_options(options, &block)
    options
  end
  
  include Subdomainr::Mapper
end

class FakeUrlRewriter
  def initialize(request=nil)
    @request = request || FakeRequest.new
  end
  
  def rewrite(options)
    options
  end

  include Subdomainr::UrlRewriter
end