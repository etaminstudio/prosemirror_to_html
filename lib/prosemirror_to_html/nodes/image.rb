module ProsemirrorToHtml
  module Nodes
    class Image < Node
      @node_type = 'image'
      @tag_name = 'img'

      def tag
        [
          {
            tag: self.class.tag_name,
            attrs: @node[:attrs]
          }
        ]
      end

      def self_closing
        true
      end
    end
  end
end
