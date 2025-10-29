# frozen_string_literal: true

require 'fileutils'

# Service to build a single PDF from multiple Markdown files using Redcarpet and WickedPdf
# Usage:
#   DocsPdfBuilder.new(markdown_paths: ["docs/overview.md", ...], title: "Technical Documentation").build(output_path: "docs/Technical_Documentation.pdf")
class DocsPdfBuilder
  DEFAULT_TITLE = "Technical Documentation"

  def initialize(markdown_paths:, title: DEFAULT_TITLE)
    @markdown_paths = markdown_paths
    @title = title
  end

  def build(output_path: File.join(Rails.root, "docs", "Technical_Documentation.pdf"))
    html = wrap_html(render_all_markdown)

    pdf_binary = WickedPdf.new.pdf_from_string(
      html,
      page_size: 'A4',
      margin: { top: 10, bottom: 10, left: 12, right: 12 },
      encoding: 'UTF-8',
      javascript_delay: 1500,
      disable_javascript: false
    )

    FileUtils.mkdir_p(File.dirname(output_path))
    File.open(output_path, 'wb') { |f| f.write(pdf_binary) }

    output_path
  end

  private

  def markdown_renderer
    @markdown_renderer ||= begin
      require 'redcarpet'
      renderer = Redcarpet::Render::HTML.new(with_toc_data: true, hard_wrap: true)
      Redcarpet::Markdown.new(
        renderer,
        autolink: true,
        tables: true,
        fenced_code_blocks: true,
        strikethrough: true,
        lax_spacing: true,
        space_after_headers: true,
        superscript: true,
        footnotes: true
      )
    end
  end

  def render_all_markdown
    @markdown_paths.map do |rel_path|
      abs_path = Rails.root.join(rel_path)
      next nil unless File.exist?(abs_path)

      content = File.read(abs_path)
      section_title = File.basename(rel_path).sub(/\.md\z/, '').tr('_-', ' ').split.map(&:capitalize).join(' ')
      rendered = markdown_renderer.render(content)
      rendered = transform_mermaid_blocks(rendered)
      <<~HTML
        <div class="doc-section">
          <h1>#{section_title}</h1>
          #{rendered}
        </div>
      HTML
    end.compact.join("\n\n")
  end

  def wrap_html(body)
    <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8" />
          <title>#{@title}</title>
          <style>
            body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; font-size: 12px; line-height: 1.5; color: #111; }
            h1, h2, h3 { color: #0d3b66; }
            h1 { border-bottom: 1px solid #eee; padding-bottom: 4px; }
            code, pre { font-family: SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace; font-size: 11px; }
            pre { background: #f7f7f7; padding: 8px; border-radius: 4px; overflow: auto; }
            table { border-collapse: collapse; width: 100%; }
            th, td { border: 1px solid #ddd; padding: 6px; }
            .title-page { text-align: center; margin-top: 140px; }
            .title-page h1 { font-size: 28px; }
            .meta { color: #666; margin-top: 6px; }
            .doc-section { page-break-inside: avoid; }
            .page-break { page-break-after: always; }
          </style>
          <script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
          <script>
            document.addEventListener('DOMContentLoaded', function() {
              if (window.mermaid) { mermaid.initialize({ startOnLoad: true, securityLevel: 'loose' }); }
            });
          </script>
        </head>
        <body>
          <div class="title-page">
            <h1>#{@title}</h1>
            <div class="meta">Generated at #{Time.now.utc.strftime('%Y-%m-%d %H:%M UTC')}</div>
          </div>
          <div class="page-break"></div>
          #{body}
        </body>
      </html>
    HTML
  end

  # Convert <pre><code class="language-mermaid">... to <div class="mermaid">...</div>
  def transform_mermaid_blocks(html)
    html.gsub(/<pre>\s*<code class="language-mermaid">([\s\S]*?)<\/code>\s*<\/pre>/) do
      content = Regexp.last_match(1)
      "<div class=\"mermaid\">#{content}</div>"
    end
  end
end
