require 'spec/spec_helper'

describe Subdomainr::Route do
  context 'without any subdomainr conditions' do
    subject { FakeRoute.new }

    describe '#recognition_conditions' do
      def subject; super.recognition_conditions; end
      
      it 'generates no extra recognition_conditions clauses' do
        should == ['conditions[:default]']
      end
    end
  end
  
  describe ':subdomain' do
    describe '=> true' do
      subject { FakeRoute.new :subdomain => true }
      
      it { should recognize :subdomain => "anything" }
      it { should_not recognize :subdomain => false }
    end

    describe '=> false' do
      subject { FakeRoute.new :subdomain => false }

      it { should recognize :subdomain => false }
      it { should_not recognize :subdomain => 'anything' }
    end

    describe '=> /.../' do
      subject { FakeRoute.new :subdomain => /^match/ }
      
      it { should recognize :subdomain => 'matches' }
      it { should_not recognize :subdomain => 'notmatch' }
      it { should_not recognize :subdomain => false }
    end

    describe '=> proc { ... }' do
      subject { FakeRoute.new :subdomain => proc { |subdomain| subdomain == 'match' } }

      it { should recognize :subdomain => 'match' }
      it { should_not recognize :subdomain => 'notmatch' }
    end

    describe '=> "..."' do
      subject { FakeRoute.new :subdomain => 'match' }
      
      it { should recognize :subdomain => 'match' }
      it { should_not recognize :subdomain => 'notmatch' }
    end
  end
  
  describe ':not_subdomain' do
    describe '=> true' do
      subject { FakeRoute.new :not_subdomain => true }

      it { should_not recognize :subdomain => 'anything' }
      it { should recognize :subdomain => false }
    end

    describe '=> false' do
      subject { FakeRoute.new :not_subdomain => false }
      
      it { should_not recognize :subdomain => false }
      it { should recognize :subdomain => "anything" }
    end

    describe '=> /.../' do
      subject { FakeRoute.new :not_subdomain => /^match/ }
      
      it { should_not recognize :subdomain => 'matches' }
      it { should recognize :subdomain => 'notmatch' }
      it { should recognize :subdomain => false }
    end

    describe '=> proc { ... }' do
      subject { FakeRoute.new :not_subdomain => proc { |subdomain| subdomain == 'match' } }

      it { should_not recognize :subdomain => 'match' }
      it { should recognize :subdomain => 'notmatch' }
    end

    describe '=> "..."' do
      subject { FakeRoute.new :not_subdomain => 'match' }
      
      it { should_not recognize :subdomain => 'match' }
      it { should recognize :subdomain => 'notmatch' }
    end
  end
  
  describe ':no_subdomain' do
    describe '=> true' do
      subject { FakeRoute.new :no_subdomain => true }
      
      it { should recognize :subdomain => false }
      it { should_not recognize :subdomain => "anything" }
    end

    describe '=> false' do
      subject { FakeRoute.new :no_subdomain => false }
      
      it { should recognize :subdomain => "anything" }
      it { should_not recognize :subdomain => false }
    end
  end
  
  describe ':domain' do
    describe '=> /.../' do
      subject { FakeRoute.new :domain => /^match/ }
      
      it { should recognize :domain => 'matches' }
      it { should_not recognize :domain => 'notmatch' }
    end

    describe '=> proc { ... }' do
      subject { FakeRoute.new :domain => proc { |subdomain| subdomain == 'match' } }

      it { should recognize :domain => 'match' }
      it { should_not recognize :domain => 'notmatch' }
    end

    describe '=> "..."' do
      subject { FakeRoute.new :domain => 'match' }
      
      it { should recognize :domain => 'match' }
      it { should_not recognize :domain => 'notmatch' }
    end
  end
  
  describe ':not_domain' do
    describe '=> /.../' do
      subject { FakeRoute.new :not_domain => /^match/ }
      
      it { should_not recognize :domain => 'matches' }
      it { should recognize :domain => 'notmatch' }
    end

    describe '=> proc { ... }' do
      subject { FakeRoute.new :not_domain => proc { |subdomain| subdomain == 'match' } }

      it { should_not recognize :domain => 'match' }
      it { should recognize :domain => 'notmatch' }
    end

    describe '=> "..."' do
      subject { FakeRoute.new :not_domain => 'match' }
      
      it { should_not recognize :domain => 'match' }
      it { should recognize :domain => 'notmatch' }
    end
  end
end