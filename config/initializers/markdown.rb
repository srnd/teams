$markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape_html: true), autolink: true, tables: true)
