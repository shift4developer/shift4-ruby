# frozen_string_literal: true

def each_context(*contexts, &block)
  contexts.each do |context|
    context context do
      include_context context
      instance_eval(&block)
    end
  end
end
