module ProsemirrorToHtml
  module Nodes
    class Heading < Node
      @node_type = 'heading'

      def tag
        [
          {
            tag: "h#{@node[:attrs][:level]}",
            attrs: tag_attrs
          }
        ]
      end

      private

      def tag_attrs
        attrs_hash = @node[:attrs].to_h
        attrs_hash.slice(*attrs_hash.keys - %i[level])
      end
    end
  end
end
