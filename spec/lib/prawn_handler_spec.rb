require 'spec_helper'

module Prawn
  class Document
    def initialize
      @calls = []
    end

    def explicit_call
      @calls << :explicit_call
    end

    def implicit_call
      @calls << :implicit_call
    end

    def render
      @calls.inspect
    end
  end
end

describe 'PrawnHandler' do
  it 'test_compatibility_with_action_view' do
    pending 'It is partly ported from old test unit'
    view = ActionView::Base.new
    result = view.render file: File.dirname(__FILE__) + '/test.pdf.prawn'
    result.should eq '[:explicit_call, :implicit_call]'
  end
end
