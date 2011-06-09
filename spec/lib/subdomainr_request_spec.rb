require 'spec/spec_helper'

describe Subdomainr::Request do
  let :request do
    FakeRequest.new
  end

  describe '.domain' do
    context 'with no domain configured' do
      before :each do
        Subdomainr.domains = []
      end

      it 'passes through the original domain method' do
        request.domain.should == 'domain'
      end

      it 'uses the configured or default tld size' do
        Subdomainr.tld_size = 2
        mock(request).domain_without_subdomainr(2) { 'another' }
        request.domain.should == 'another'
      end
    end

    context 'with a non-matching domain configured' do
      before :each do
        Subdomainr.domains = ['non-matching']
      end

      it 'passes through the original domain method' do
        request.domain.should == 'domain'
      end

      it 'uses the configured or default tld size' do
        Subdomainr.tld_size = 2
        mock(request).domain_without_subdomainr(2) { 'another' }
        request.domain.should == 'another'
      end
    end

    context 'with a matching domain configured' do
      let :request do
        FakeRequest.new :host => 'subdomain.matching'
      end

      before :each do
        Subdomainr.domain = 'matching'
      end

      it 'returns the matching domain' do
        request.domain.should == 'matching'
      end

      it 'still passes calls with an explicit tld_size through' do
        mock(request).domain_without_subdomainr(2) { 'another' }
        request.domain(2).should == 'another'
      end
    end
  end

  describe '.subdomain' do
    it 'returns the subdomain' do
      request.subdomain.should == 'subdomain'
    end

    context 'with no subdomain' do
      let :request do
        FakeRequest.new :host => 'domain', :domain => 'domain'
      end

      it 'returns false' do
        request.subdomain.should == false
      end
    end

    context 'with an ignored subdomain' do
      let :request do
        FakeRequest.new :host => 'www.domain', :domain => 'domain'
      end

      it 'returns false' do
        request.subdomain.should == false
      end
    end
  end
end
