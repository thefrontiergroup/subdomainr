require 'spec/spec_helper'

describe Subdomainr::RouteSet do
  let :request do
    FakeRequest.new :host => 'ahost', :domain => 'adomain', :subdomain => 'asubdomain', :something => 'else'
  end
  
  let :route_set do
    FakeRouteSet.new
  end
  
  def subject
    route_set.extract_request_environment(request)
  end
  
  describe '#extract_request_environment' do
    it { should include :host, :domain, :subdomain, :original }
    it { subject[:host].should == 'ahost' }
  end
end