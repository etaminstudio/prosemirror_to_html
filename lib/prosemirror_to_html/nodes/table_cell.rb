module ProsemirrorToHtml
  module Nodes
    class TableCell < Node
      @node_type = 'table_cell'
      @tag_name = 'td'

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
