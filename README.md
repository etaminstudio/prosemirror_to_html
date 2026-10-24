# ProsemirrorToHtml

> [!WARNING]
> **This gem is deprecated.** Use [`prosemirror`](https://github.com/etaminstudio/prosemirror) instead, from the same maintainers. It builds the HTML with Phlex, which escapes text and attribute values as it writes them, types attributes and only allows safe URL schemes, instead of building strings and cleaning them up afterwards. It also imports HTML and Markdown, and exports Markdown and text. See the [migration guide](https://github.com/etaminstudio/prosemirror/blob/main/MIGRATING.md).
>
> This gem won't get new features.

Takes ProseMirror compatible JSON and outputs HTML.

## Usage

```ruby
ProsemirrorToHtml::Renderer.new.render(json)
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
