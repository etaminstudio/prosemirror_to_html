## [0.3.1] - 2026-02-23

### Fixed

- Remove unwanted debug output

## [0.3.0] - 2026-02-18

### Changed

- Remove dependency to `OpenStruct`

### Fixed

- Fix mark grouping: marks shared across adjacent text nodes (e.g. a `link` spanning multiple runs) are now correctly rendered as a single wrapping tag instead of being reopened for each node

## [0.2.1] - 2025-11-05

- Escape attributes values [CVE-2025-64501]

## [0.2.0] - 2023-07-03

Hans Lemuet (@Spone) is the new maintainer. The fork is now hosted at https://github.com/etaminstudio/prosemirror_to_html

### Added

- Added support for marks `Strike`, `Subscript`, `Superscript`, `Underline`
- Added support for nodes `Blockquote`, `HorizontalRule`, `Table`, `TableCell`, `TableHeader`, `TableRow`
- `Link` mark: added support for conditional `target`, `title`, `rel` attributes
- `Heading` node: added support for `level` attribute

### Changed

- Improve code style (always use snake_case for methods)
- Refactor `Renderer`
- Refactor `Node`
- Refactor specs to have one spec file for each node and mark
- Update dependencies

### Removed

- `CodeBlockWrapper` node removed in favor of `CodeBlock`
- `Text` node removed
- `User` node removed
