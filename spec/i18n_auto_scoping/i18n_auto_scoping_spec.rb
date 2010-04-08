require File.dirname(__FILE__) + '/../spec_helper'

describe :i18n_auto_scoping do
  before(:all) do
    @v = ActionView::Base.new([File.join(File.dirname(__FILE__), '../app/views/')], {}, FakeController.new)
  end

  it "should still keep working without scope" do
    I18n.t(:hi).should == 'Hello'
  end

  it "should still keep working with scope" do
    I18n.t(:hi, :scope => :bam).should == 'Hello in Bam'
  end

  it "Should works with scope temporarly changed" do
    I18n::Scope.temporarly_change(:test_scope) do
      I18n.t(:hi).should == 'Hello in Test Scope'
    end
  end

  it "Should works with action view template" do
    @v.render(:file => 'view').should == 'Hello in view'
  end

  it "Should work with action view partial without the underscore" do
    @v.render('partial').should == 'Hello in partial'
  end

  it "Should works with action view nested template" do
    @v.render(:file => 'nested').should == 'Hello in partial'
  end

  it "Should works with action view nested nested template" do
    @v.render(:file => 'nested_nested').should == 'Hello in nested partial'
  end
  
  it "Should works with scope temporarly changed in view" do
    @v.render(:file => 'view_with_temporarly_change').should == 'Hello in Test Scope'
  end

end