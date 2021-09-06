RSpec.describe ProsemirrorToHtml::Nodes::Heading do
  it 'renders correctly' do
    json = {
      type: 'doc',
      content: [
        {
          type: 'heading',
          attrs: {
            level: 2
          },
          content: [
            {
              type: 'text',
              text: 'Example Headline'
            }
          ]
        }
      ]
    }

    html = '<h2>Example Headline</h2>'

    renderer = ProsemirrorToHtml::Renderer.new
    expect(renderer.render(json)).to eq html
  end
end