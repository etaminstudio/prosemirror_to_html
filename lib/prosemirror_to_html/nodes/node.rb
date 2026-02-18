module ProsemirrorToHtml
  module Nodes
    class Node
      @node_type = nil
      @tag_name = nil

      class << self
        attr_reader :node_type, :tag_name
      end

      def initialize(node)
        @node = node
      end

      def matching
        return underscore(@node[:type]) == self.class.node_type if @node[:type]

        false
      end

      def self_closing
        false
      end

      def tag
        self.class.tag_name
      end

      def text
        nil
      end

      private

      # from https://github.com/rails/rails/blob/83217025a171593547d1268651b446d3533e2019/activesupport/lib/active_support/inflector/methods.rb#L92
      def underscore(camel_cased_word)
        return camel_cased_word unless /[A-Z-]|::/.match?(camel_cased_word)

        word = camel_cased_word.to_s.gsub("::", "/")
        word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word
      end
    end
  end
end
