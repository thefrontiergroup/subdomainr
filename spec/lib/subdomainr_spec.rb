require 'spec/spec_helper'

describe Subdomainr do
  # Reset Subdomainr back to freshly-loaded each time.
  before :each do
    Subdomainr.class_variables.each do |name|
      Subdomainr.send :class_variable_set, name, nil
    end
  end

  context 'with no domains' do
    describe '.domain' do
      it 'returns nil' do
        Subdomainr.domain.should be_nil
      end
    end

    describe '.domain=' do
      it 'sets domains to be an array of one' do
        Subdomainr.domain = 'one'
        Subdomainr.domains.should == ['one']
      end
    end

    describe '.domains' do
      it 'returns an empty array' do
        Subdomainr.domains.should be_an Array
        Subdomainr.domains.should be_empty
      end
    end

    describe '.domains=' do
      it 'should set all domains' do
        Subdomainr.domains = ['one']
        Subdomainr.domains.should == ['one']
      end
    end
  end

  context 'with one domain' do
    before :each do
      Subdomainr.send :class_variable_set, '@@domains', ['one']
    end

    describe '.domain' do
      it 'returns the domain' do
        Subdomainr.domain.should == 'one'
      end
    end

    describe '.domain=' do
      it 'replaces the domain' do
        Subdomainr.domain = 'another'
        Subdomainr.domains.should == ['another']
      end
    end

    describe '.domains' do
      it 'returns an array including only the domain' do
        Subdomainr.domains.should == ['one']
      end
    end

    describe '.domains=' do
      it 'should replace the domain with specified array' do
        Subdomainr.domains = ['another', 'couple']
        Subdomainr.domains.should == ['another', 'couple']
      end
    end
  end

  context 'with many domains' do
    before :each do
      Subdomainr.send :class_variable_set, '@@domains', ['one', 'two', 'three']
    end

    describe '.domain' do
      it 'returns the first domain' do
        Subdomainr.domain.should == 'one'
      end
    end

    describe '.domain=' do
      it 'replaces all domains with one' do
        Subdomainr.domain = 'another'
        Subdomainr.domains.should == ['another']
      end
    end

    describe '.domains' do
      it 'returns all domains' do
        Subdomainr.domains.should == ['one', 'two', 'three']
      end
    end

    describe '.domains=' do
      it 'should replace the domain with specified array' do
        Subdomainr.domains = ['another', 'couple']
        Subdomainr.domains.should == ['another', 'couple']
      end
    end
  end

  describe '.ignored_subdomains' do
    it 'should return the default subdomains' do
      Subdomainr.ignored_subdomains.should =~ ["www"]
    end

    context 'when emptied' do
      before :each do
        Subdomainr.send(:class_variable_set, '@@ignored_subdomains', [])
      end

      it 'should return an empty list' do
        Subdomainr.ignored_subdomains.should be_empty
      end
    end

    context 'when appended to' do
      before :each do
        Subdomainr.ignored_subdomains << "www2"
      end

      it 'should contain the default subdomain' do
        Subdomainr.ignored_subdomains.should include "www"
      end

      it 'should contain the appended subdomain' do
        Subdomainr.ignored_subdomains.should include "www2"
      end
    end
  end

  describe '.tld_size' do
    it 'should return the default tld_size' do
      Subdomainr.tld_size.should == 1
    end

    context 'with a tld size set' do
      before :each do
        Subdomainr.send(:class_variable_set, '@@tld_size', 2)
      end

      it 'should return the set tld_size' do
        Subdomainr.tld_size.should == 2
      end
    end
  end

  describe '.tld_size=' do

    it 'should set the tld size' do
      Subdomainr.tld_size = 2
      Subdomainr.send(:class_variable_get, '@@tld_size').should == 2
    end

  end

  describe '.domain_from_host' do
    before :each do
      Subdomainr.domain = 'matching'
    end

    it 'returns nil when there are no matching domains' do
      Subdomainr.domain_from_host('not').should be_nil
    end

    it 'returns nil for a host with a similarly-ending domain' do
      Subdomainr.domain_from_host('notmatching').should be_nil
    end

    it 'returns the domain matching a bare domain host' do
      Subdomainr.domain_from_host('matching').should == 'matching'
    end

    it 'returns the domain matching a bare domain host prefixed by a period' do
      Subdomainr.domain_from_host('.matching').should == 'matching'
    end

    it 'returns the domain matching a domain host with a subdomain' do
      Subdomainr.domain_from_host('subdomain.matching').should == 'matching'
    end
  end
end
