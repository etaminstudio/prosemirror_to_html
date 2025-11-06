module ProsemirrorToHtml
  module Nodes
    class OrderedList < Node
      @node_type = 'ordered_list'
      @tag_name = 'ol'

      def tag
        [
          {
            tag: self.class.tag_name,
            attrs: @node[:attrs]
          }
        ]
      end
    end
  end
end
