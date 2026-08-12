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

  it 'renders correctly with an ID' do
    json = {
      type: 'doc',
      content: [
        {
          type: 'heading',
          attrs: {
            level: 2,
            id: 'example-headline'
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

    html = '<h2 id="example-headline">Example Headline</h2>'

    renderer = ProsemirrorToHtml::Renderer.new
    expect(renderer.render(json)).to eq html
  end

  it 'clamps an out-of-range level to a valid heading' do
    json = {
      type: 'doc',
      content: [
        {
          type: 'heading',
          attrs: { level: 9 },
          content: [{ type: 'text', text: 'Example Headline' }]
        }
      ]
    }

    html = '<h6>Example Headline</h6>'

    renderer = ProsemirrorToHtml::Renderer.new
    expect(renderer.render(json)).to eq html
  end

  it 'does not let the level steer the tag name' do
    json = {
      type: 'doc',
      content: [
        {
          type: 'heading',
          attrs: { level: '1><script>alert(1)</script' },
          content: [{ type: 'text', text: 'hi' }]
        }
      ]
    }

    html = '<h1>hi</h1>'

    renderer = ProsemirrorToHtml::Renderer.new
    expect(renderer.render(json)).to eq html
  end
end
