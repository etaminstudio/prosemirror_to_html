module ProsemirrorToHtml
  module Nodes
    class Heading < Node
      @node_type = 'heading'

      def tag
        [
          {
            tag: "h#{level}",
            attrs: tag_attrs
          }
        ]
      end

      private

      # Coerce and clamp the level to a valid heading (1-6) so a
      # document-supplied value cannot steer the tag name.
      def level
        @node[:attrs][:level].to_i.clamp(1, 6)
      end

      def tag_attrs
        attrs_hash = @node[:attrs].to_h
        attrs_hash.slice(*attrs_hash.keys - %i[level])
      end
    end
  end
end
