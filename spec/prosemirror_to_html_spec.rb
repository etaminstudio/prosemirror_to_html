RSpec.describe ProsemirrorToHtml do
  it "has a version number" do
    expect(ProsemirrorToHtml::VERSION).not_to be nil
  end

  it "renders complex html correctly" do
    html = "<h1>Headline 1</h1><p> Some text. <strong>Bold Text</strong>. <em>Italic Text</em>. <strong><em>Bold and italic Text</em></strong>. Here is a <a href=\"https://input.com\">Link</a></p>"

    json = {
      type: 'doc',
      content: [{
        type: 'heading',
        attrs: {
          level: '1'
        },
        content: [{
          type: 'text',
          text: 'Headline 1',
        }]
      },{
        type: 'paragraph',
        content: [{
          type: 'text',
          text: ' Some text. ',
        }, {
          type: 'text',
          text: 'Bold Text',
          marks:[{
            type: 'bold',
          }]
        },{
          type: 'text',
          text: '. ',
        }, {
          type: 'text',
          text: 'Italic Text',
          marks:[{
            type: 'italic',
          }]
        },{
          type: 'text',
          text: '. ',
        }, {
          type: 'text',
          text: 'Bold and italic Text',
          marks:[{
            type: 'bold',
          }, {
            type: 'italic',
          }]
        },{
          type: 'text',
          text: '. Here is a ',
        },{
          type: 'text',
          text: 'Link',
          marks: [{
            type: 'link',
            attrs: {
              href: 'https://input.com'
            }
          }]
        }]
      }]
    }

    renderer = ProsemirrorToHtml::Renderer.new
    expect(renderer.render(json)).to eq(html)
  end

  it 'renders example json correctly' do
    json = '{
      "type": "doc",
      "content": [
        {
          "type": "heading",
          "attrs": {
            "level": 2
          },
          "content": [
            {
              "type": "text",
              "text": "Export HTML or JSON"
            }
          ]
        },
        {
          "type": "paragraph",
          "content": [
            {
              "type": "text",
              "text": "You are able to export your data as "
            },
            {
              "type": "text",
              "marks": [
                {
                  "type": "code"
                }
              ],
              "text": "HTML"
            },
            {
              "type": "text",
              "text": " or "
            },
            {
              "type": "text",
              "marks": [
                {
                  "type": "code"
                }
              ],
              "text": "JSON"
            },
            {
              "type": "text",
              "text": ". To pass "
            },
            {
              "type": "text",
              "marks": [
                {
                  "type": "code"
                }
              ],
              "text": "HTML"
            },
            {
              "type": "text",
              "text": " to the editor use the "
            },
            {
              "type": "text",
              "marks": [
                {
                  "type": "code"
                }
              ],
              "text": "content"
            },
            {
              "type": "text",
              "text": " slot. To pass "
            },
            {
              "type": "text",
              "marks": [
                {
                  "type": "code"
                }
              ],
              "text": "JSON"
            },
            {
              "type": "text",
              "text": " to the editor use the "
            },
            {
              "type": "text",
              "marks": [
                {
                  "type": "code"
                }
              ],
              "text": "doc"
            },
            {
              "type": "text",
              "text": " prop."
            }
          ]
        }
      ]
    }'

    html = '<h2>Export HTML or JSON</h2><p>You are able to export your data as <code>HTML</code> or <code>JSON</code>. To pass <code>HTML</code> to the editor use the <code>content</code> slot. To pass <code>JSON</code> to the editor use the <code>doc</code> prop.</p>'

    renderer = ProsemirrorToHtml::Renderer.new
    expect(renderer.render(json)).to eq(html)
  end

  it 'prevents javascript links' do
    escaped_html = '<p><a>Test</a></p>'

    json = {
      "type": "doc",
      "content": [
        {
          "type": "paragraph",
          "content": [
            {
              "type": "text",
              "text": "Test",
              "marks": [
                {
                  "type": "link",
                  "attrs": {
                    "href": "javascript:alert('Hello!')"
                  }
                }
              ]
            }
          ]
        }
      ]
    }

    renderer = ProsemirrorToHtml::Renderer.new
    expect(renderer.render(json)).to eq(escaped_html)
  end
end
