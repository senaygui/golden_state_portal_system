# Testing

- Framework: RSpec (`rspec-rails`)
- Spec directory: `spec/`
- Run all tests:

```bash
bundle exec rspec
```

Suggested structure (if not already present):
- `spec/models/*_spec.rb`
- `spec/controllers/*_spec.rb`
- `spec/requests/*_spec.rb`
- `spec/features/*_spec.rb`

Use factories (FactoryBot) if added; currently not listed in Gemfile.
