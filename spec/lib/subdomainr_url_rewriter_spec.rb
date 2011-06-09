require 'spec/spec_helper'

describe Subdomainr::UrlRewriter do
  let :url_rewriter do
    FakeUrlRewriter.new
  end
  
  subject { url_rewriter }
  
  describe '#rewrite' do
    context 'with non-Hash arguments' do
      subject { url_rewriter.rewrite('non-hash') }
      
      it 'passes through' do
        should == 'non-hash'
      end
    end
    
    context 'with hash arguments including :only_path => true' do
      hash_args = {:path => 'blah', :only_path => 'true', :subdomain => false}
      
      subject { url_rewriter.rewrite(hash_args) }
      
      it 'passes through' do
        should == hash_args
      end
    end
    
    context 'with hash arguments' do
      hash_args = {:hash => 'args'}
      
      subject { url_rewriter.rewrite(hash_args) }
      
      it 'passes through' do
        should == hash_args
      end
    end
    
    context 'with hash arguments including a :domain' do
      hash_args = {:hash => 'args', :domain => 'another'}

      subject { url_rewriter.rewrite(hash_args) }
      
      it 'rewrites :host and removes :domain' do
        should include :host
        should_not include :domain
        subject[:host].should == 'subdomain.another'
      end
    end
    
    context 'with hash arguments including a :subdomain' do
      hash_args = {:hash => 'args', :subdomain => 'subdomain'}
      
      subject { url_rewriter.rewrite(hash_args) }
      
      it 'rewrites :host and removes :subdomain' do
        should include :host
        should_not include :subdomain
        subject[:host].should == 'subdomain.domain'
      end
    end
    
    context 'with hash arguments including :subdomain => false' do
      hash_args = {:hash => 'args', :subdomain => false}
      
      subject { url_rewriter.rewrite(hash_args) }
      
      it 'rewrites :host and removes :subdomain' do
        should include :host
        should_not include :subdomain
        subject[:host].should == 'domain'
      end
    end
    
    context 'with hash arguments including both a :domain and a :subdomain' do
      hash_args = {:hash => 'args', :subdomain => 'another', :domain => 'secondary'}
      
      subject { url_rewriter.rewrite(hash_args) }
      
      it 'rewrites :host and removes :domain and :subdomain' do
        should include :host
        should_not include :domain
        should_not include :subdomain
        subject[:host].should == 'another.secondary'
      end
    end
    
    context 'with hash arguments including both a :domain and :subdomain => false' do
      hash_args = {:hash => 'args', :subdomain => false, :domain => 'secondary'}
      
      subject { url_rewriter.rewrite(hash_args) }
      
      it 'rewrites :host and removes :domain and :subdomain' do
        should include :host
        should_not include :domain
        should_not include :subdomain
        subject[:host].should == 'secondary'
      end
    end
  end
end