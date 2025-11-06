module ProsemirrorToHtml
  module Marks
    class Link < Mark
      @mark_type = 'link'
      @tag_name = 'a'

      def tag
        [
          {
            tag: self.class.tag_name,
            attrs: @mark[:attrs]
          }
        ]
      end
    end
  end
end
