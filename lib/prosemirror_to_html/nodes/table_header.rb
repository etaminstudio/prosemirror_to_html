module ProsemirrorToHtml
  module Nodes
    class TableHeader < TableCell
      @node_type = 'table_header'
      @tag_name = 'th'

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
