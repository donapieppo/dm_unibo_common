# Repository Guidelines

## Project Structure & Module Organization
- Rails engine code lives in `app/` (controllers, views, components) and `lib/` (engine entrypoint, helpers, generators). Shared assets ship from `js/`, `scss/`, and `public/`.
- Specs sit under `spec/` with a dummy Rails app in `spec/dummy` for integration-style checks; factories are in `spec/factories`.
- Built gems land in `pkg/`; documentation and misc notes live in `doc/` and `README.md`.

## Build, Test, and Development Commands
- `bundle install && npm install` to set up Ruby and JS dependencies for the engine and asset pipeline.
- `bundle exec rspec` runs the test suite against the dummy app using SQLite and FactoryBot fixtures.
- `bundle exec rake build` creates the `.gem` package in `pkg/`; `bundle exec rake release` tags and pushes when ready.
- During UI work, use `bin/rails s` inside `spec/dummy` to exercise the engine in a running Rails app; add `./bin/rails css:build` or `./bin/rails javascript:build` there if you tweak PostCSS/esbuild assets.

## Coding Style & Naming Conventions
- Ruby: 2-space indentation, double quotes for strings that interpolate, concise controllers and policies; prefer service modules in `lib/` when code is reused across apps.
- JavaScript: ES modules with Stimulus/Turbo helpers; keep controller names kebab-cased (e.g., `turbo-modal`), files in `js/` camelCased where matching exports.
- SCSS: use existing PostCSS pipeline; scope component styles under meaningful class blocks to avoid leaking into host apps.

## Testing Guidelines
- Add specs in `spec/**/*_spec.rb`; mirror engine behavior using the dummy app routes and models. Use FactoryBot factories to keep fixtures consistent.
- Favor request/controller specs for authentication and authorization flows and model specs for permission rules.
- Keep tests idempotent; DatabaseCleaner and transactional fixtures are enabled in `spec/rails_helper.rb`.

## Commit & Pull Request Guidelines
- Follow the repo history: short, imperative messages (`fonts`, `omniauth`, `esbuild version`). Group related changes per commit.
- PRs should state purpose, scope, and testing done; link issues when present. Include screenshots or console logs for UI or API changes, and call out migrations/config keys added to `config/dm_unibo_common.yml`.

## Security & Configuration Tips
- Do not commit secrets; sample values belong in `config/dm_unibo_common.yml` templates only. Prefer environment-driven overrides in consuming apps.
- OAuth/shibboleth changes should note expected hosts and callback paths so downstream apps can mirror settings.
