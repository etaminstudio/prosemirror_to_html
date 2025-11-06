require "prosemirror_to_html/version"
require "prosemirror_to_html/marks/mark"
require "prosemirror_to_html/marks/bold"
require "prosemirror_to_html/marks/code"
require "prosemirror_to_html/marks/italic"
require "prosemirror_to_html/marks/link"
require "prosemirror_to_html/marks/strike"
require "prosemirror_to_html/marks/subscript"
require "prosemirror_to_html/marks/superscript"
require "prosemirror_to_html/marks/underline"
require "prosemirror_to_html/nodes/node"
require "prosemirror_to_html/nodes/blockquote"
require "prosemirror_to_html/nodes/bullet_list"
require "prosemirror_to_html/nodes/code_block"
require "prosemirror_to_html/nodes/hard_break"
require "prosemirror_to_html/nodes/horizontal_rule"
require "prosemirror_to_html/nodes/heading"
require "prosemirror_to_html/nodes/image"
require "prosemirror_to_html/nodes/list_item"
require "prosemirror_to_html/nodes/ordered_list"
require "prosemirror_to_html/nodes/paragraph"
require "prosemirror_to_html/nodes/table"
require "prosemirror_to_html/nodes/table_cell"
require "prosemirror_to_html/nodes/table_header"
require "prosemirror_to_html/nodes/table_row"
require 'nokogiri'
require 'json'

module ProsemirrorToHtml
  class Error < StandardError; end

  class Renderer
    def initialize
      @document = nil

      @nodes = [
        ProsemirrorToHtml::Nodes::Blockquote,
        ProsemirrorToHtml::Nodes::BulletList,
        ProsemirrorToHtml::Nodes::CodeBlock,
        ProsemirrorToHtml::Nodes::HardBreak,
        ProsemirrorToHtml::Nodes::Heading,
        ProsemirrorToHtml::Nodes::HorizontalRule,
        ProsemirrorToHtml::Nodes::Image,
        ProsemirrorToHtml::Nodes::ListItem,
        ProsemirrorToHtml::Nodes::OrderedList,
        ProsemirrorToHtml::Nodes::Paragraph,
        ProsemirrorToHtml::Nodes::Table,
        ProsemirrorToHtml::Nodes::TableCell,
        ProsemirrorToHtml::Nodes::TableHeader,
        ProsemirrorToHtml::Nodes::TableRow,
      ]

      @marks = [
        ProsemirrorToHtml::Marks::Bold,
        ProsemirrorToHtml::Marks::Code,
        ProsemirrorToHtml::Marks::Italic,
        ProsemirrorToHtml::Marks::Link,
        ProsemirrorToHtml::Marks::Strike,
        ProsemirrorToHtml::Marks::Subscript,
        ProsemirrorToHtml::Marks::Superscript,
        ProsemirrorToHtml::Marks::Underline,
      ]
    end

    def with_marks(marks = nil)
      @marks = marks if marks.is_a? Array

      self
    end

    def with_nodes(nodes = nil)
      @nodes = nodes if nodes.is_a? Array

      self
    end

    def render(value)
      json = case value
             when Hash then value.to_json
             when String then value
             else raise Error
             end

      @document = JSON.parse(json, symbolize_names: true)

      html = ''

      content = @document[:content].is_a?(Array) ? @document[:content] : []

      content.each_with_index do |node, index|
        prev_node = content[index - 1]
        next_node = content[index + 1]

        html << render_node(node, prev_node, next_node)
      end

      html
    end

    def add_node(node)
      @nodes << node

      self
    end

    def add_nodes(nodes)
      @nodes.push nodes

      self
    end

    def add_mark(mark)
      @marks << mark

      self
    end

    def add_marks(marks)
      @marks.push marks

      self
    end

    def replace_node(search_node, replace_node)
      @nodes.each do |key, node_klass|
        if node_klass == search_node
          @nodes[key] = replace_node
        end
      end

      self
    end

    def replace_mark(search_mark, replace_mark)
      @marks.each do |key, mark_klass|
        if mark_klass == search_mark
          @marks[key] = replace_mark
        end
      end

      self
    end

    private

    def render_node(node, prev_node, next_node)
      html = ''
      render_klass = nil

      node[:marks]&.each do |mark|
        @marks.each do |klass|
          render_klass = klass.new(mark)

          if render_klass.matching && mark_should_open(mark, prev_node)
            html << render_opening_tag(render_klass.tag)
          end
        end
      end

      @nodes.each do |klass|
        render_klass = klass.new(node)

        if render_klass.matching
          html << render_opening_tag(render_klass.tag)
          break
        end
      end

      if node[:content]
        node[:content].each_with_index do |nested_node, index|
          prev_nested_node = node[:content][index - 1]
          next_nested_node = node[:content][index + 1]

          html << render_node(nested_node, prev_nested_node, next_nested_node)
          prev_node = nested_node
        end
      elsif node[:text]
        html << CGI.escapeHTML(node[:text])
      elsif (text = render_klass.text)
        html << text
      end

      @nodes.each do |klass|
        render_klass = klass.new(node)

        if render_klass.self_closing
          next
        end

        if render_klass.matching
          html << render_closing_tag(render_klass.tag)
        end
      end

      node[:marks]&.reverse&.each do |mark|
        @marks.each do |klass|
          render_klass = klass.new(mark)

          if render_klass.matching && mark_should_close(mark, next_node)
            html << render_closing_tag(render_klass.tag)
          end
        end
      end

      html
    end

    def mark_should_open(mark, prev_node)
      node_has_mark(prev_node, mark)
    end

    def mark_should_close(mark, next_node)
      node_has_mark(next_node, mark)
    end

    def node_has_mark(node, mark)
      return true unless node
      return true if node.respond_to?(:marks)

      # Other node has same mark
      node.marks&.each do |other_mark|
        if mark == other_mark
          return false
        end
      end

      true
    end

    def render_opening_tag(tags)
      tags = array_wrap(tags)

      return nil if tags.empty?

      tags.map do |tag|
        if tag.is_a? String
          "<#{tag}>"
        else
          attrs = ''
          tag[:attrs]&.each_pair do |attr, value|
            escaped_value = CGI.escapeHTML(value.to_s)
            attrs << " #{attr}=\"#{escaped_value}\""
          end

          "<#{tag[:tag]}#{attrs}>"
        end
      end.join
    end

    def render_closing_tag(tags)
      tags = array_wrap(tags).reverse

      return nil if tags.empty?

      tags.map do |tag|
        if tag.is_a? String
          "</#{tag}>"
        else
          "</#{tag[:tag]}>"
        end
      end.join
    end

    # From https://github.com/rails/rails/blob/5f3ff60084ab5d5921ca3499814e4697f8350ee7/activesupport/lib/active_support/core_ext/array/wrap.rb
    def array_wrap(object)
      if object.nil?
        []
      elsif object.respond_to?(:to_ary)
        object.to_ary || [object]
      else
        [object]
      end
    end
  end
end
