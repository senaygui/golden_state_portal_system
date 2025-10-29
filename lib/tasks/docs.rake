# frozen_string_literal: true

namespace :docs do
  desc 'Build a single Technical_Documentation.pdf from docs/*.md'
  task build_pdf: :environment do
    files = [
      'docs/Technical_Documentation.md',
      'docs/overview.md',
      'docs/setup.md',
      'docs/configuration.md',
      'docs/operations.md',
      'docs/architecture.md',
      'docs/data_model.md',
      'docs/routes.md',
      'docs/admin.md',
      'docs/testing.md',
      'docs/security.md',
      'docs/troubleshooting.md'
    ]

    builder = DocsPdfBuilder.new(markdown_paths: files, title: 'Technical Documentation')
    output = File.join(Rails.root, 'docs', 'Technical_Documentation.pdf')
    path = builder.build(output_path: output)
    puts "Generated: #{path}"
  end
end
