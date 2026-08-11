RSpec.describe 'ProsemirrorToHtml sanitization' do
  let(:renderer) { ProsemirrorToHtml::Renderer.new }

  it 'strips event-handler attributes whose name is the payload' do
    json = {
      type: 'doc',
      content: [{
        type: 'heading',
        attrs: { level: 1, onmouseover: 'alert(1)' },
        content: [{ type: 'text', text: 'hi' }]
      }]
    }

    expect(renderer.render(json)).to eq '<h1>hi</h1>'
  end

  it 'strips an attribute name that tries to break out of the attribute list' do
    json = {
      type: 'doc',
      content: [{
        type: 'heading',
        attrs: { level: 1, 'onerror=alert(1) x': 'y' },
        content: [{ type: 'text', text: 'hi' }]
      }]
    }

    expect(renderer.render(json)).to eq '<h1 x="y">hi</h1>'
  end

  it 'strips event handlers injected through a link mark' do
    json = {
      type: 'doc',
      content: [{
        type: 'paragraph',
        content: [{
          type: 'text',
          text: 'L',
          marks: [{ type: 'link', attrs: { href: 'https://example.com', onmouseover: 'alert(1)' } }]
        }]
      }]
    }

    expect(renderer.render(json)).to eq '<p><a href="https://example.com">L</a></p>'
  end

  it 'removes script tags smuggled through the heading level' do
    json = {
      type: 'doc',
      content: [{
        type: 'heading',
        attrs: { level: '1><script>alert(1)</script' },
        content: [{ type: 'text', text: 'hi' }]
      }]
    }

    expect(renderer.render(json)).not_to include('<script>')
  end

  it 'drops javascript: URLs on links' do
    json = {
      type: 'doc',
      content: [{
        type: 'paragraph',
        content: [{
          type: 'text',
          text: 'L',
          marks: [{ type: 'link', attrs: { href: 'javascript:alert(1)' } }]
        }]
      }]
    }

    expect(renderer.render(json)).to eq '<p><a>L</a></p>'
  end
end
