require 'spec/spec_helper'

describe Subdomainr::Mapper do
  let :mapper do
    FakeMapper.new
  end
  
  subject { mapper }
  
  describe '#subdomain' do
    subject { mapper.subdomain('match', :other => 'options'){ |map| } }
    
    it 'raises exception for non-true/false/String/Regexp argument' do
      proc { mapper.subdomain(Object.new) { |map| } }.should raise_exception ArgumentError
      [true, false, 'match', /match/].each do |arg|
        proc { mapper.subdomain(arg) { |map| } }.should_not raise_exception ArgumentError
      end
    end
    
    it 'should include [:conditions][:subdomain]' do
      subject.should include :conditions
      subject[:conditions].should include :subdomain
      subject[:conditions][:subdomain].should == 'match'
    end
    
    it 'should pass through other options' do
      subject.should include :other
      subject[:other].should == 'options'
    end
  end

  describe '#not_subdomain' do
    subject { mapper.not_subdomain('match', :other => 'options'){ |map| } }

    it 'raises exception for non-true/false/String/Regexp argument' do
      proc { mapper.not_subdomain(Object.new) }.should raise_exception ArgumentError
      [true, false, 'match', /match/].each do |arg|
        proc { mapper.not_subdomain(arg) }.should_not raise_exception ArgumentError
      end
    end
    
    it 'should include [:conditions][:not_subdomain]' do
      subject.should include :conditions
      subject[:conditions].should include :not_subdomain
      subject[:conditions][:not_subdomain].should == 'match'
    end
    
    it 'should pass through other options' do
      subject.should include :other
      subject[:other].should == 'options'
    end
  end

  describe '#no_subdomain' do
    subject { mapper.no_subdomain(:other => 'options') { |map| } }
    
    it 'should include [:conditions][:no_subdomain]' do
      subject.should include :conditions
      subject[:conditions].should include :no_subdomain
      subject[:conditions][:no_subdomain].should == true
    end
    
    it 'should pass through other options' do
      subject.should include :other
      subject[:other].should == 'options'
    end
  end

  describe '#domain' do
    subject { mapper.domain('match', :other => 'options'){ |map| } }

    it 'raises exception for non-String/Regexp argument' do
      proc { mapper.domain(Object.new) }.should raise_exception ArgumentError
      ['match', /match/].each do |arg|
        proc { mapper.domain(arg) }.should_not raise_exception ArgumentError
      end
    end
    
    it 'should include [:conditions][:not_domain]' do
      subject.should include :conditions
      subject[:conditions].should include :domain
      subject[:conditions][:domain].should == 'match'
    end
    
    it 'should pass through other options' do
      subject.should include :other
      subject[:other].should == 'options'
    end
  end

  describe '#not_domain' do
    subject { mapper.not_domain('match', :other => 'options'){ |map| } }

    it 'raises exception for non-String/Regexp argument' do
      proc { mapper.not_domain(Object.new) }.should raise_exception ArgumentError
      ['match', /match/].each do |arg|
        proc { mapper.not_domain(arg) }.should_not raise_exception ArgumentError
      end
    end
    
    it 'should include [:conditions][:not_domain]' do
      subject.should include :conditions
      subject[:conditions].should include :not_domain
      subject[:conditions][:not_domain].should == 'match'
    end
    
    it 'should pass through other options' do
      subject.should include :other
      subject[:other].should == 'options'
    end
  end
end