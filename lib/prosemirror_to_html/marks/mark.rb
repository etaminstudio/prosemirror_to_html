module ProsemirrorToHtml
  module Marks
    class Mark
      @mark_type = nil
      @tag_name = nil

      class << self
        attr_reader :mark_type, :tag_name
      end

      def initialize(mark)
        @mark = mark
      end

      def matching
        return @mark[:type] == self.class.mark_type if @mark[:type]

        false
      end

      def tag
        self.class.tag_name
      end
    end
  end
end
