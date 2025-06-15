# syntax=docker/dockerfile:1

# Multi-stage build: build gems and assets, then produce lean runtime image
ARG RUBY_VERSION=3.4.1

# ---- Build Stage ----
FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS build
WORKDIR /rails

# Install build dependencies and libraries for native extensions
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      libpq-dev \
      libyaml-dev \
      git \
      curl \
      pkg-config \
      tzdata \
      libssl-dev \
      zlib1g-dev \
      libxml2-dev \
      libxslt1-dev && \
    rm -rf /var/lib/apt/lists/*

# Configure Bundler and psych before installation
RUN bundle config set force_ruby_platform true && \
    bundle config build.psych --with-ldflags=-lyaml

# Install Bundler explicitly to match your lockfile
RUN gem install bundler --no-document

# Copy and install gems
COPY Gemfile Gemfile.lock ./
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_DEPLOYMENT=1
RUN gem install psych -v 5.1.0 && \
    bundle _$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1 | tr -d ' ')_ install --jobs 2 --retry 3

# Copy application code and precompile assets
COPY . .
# RUN RAILS_ENV=production bundle exec rake assets:precompile

# ---- Runtime Stage ----
FROM docker.io/library/ruby:${RUBY_VERSION}-slim
WORKDIR /rails

# Install runtime dependencies (no build tools)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      libpq5 \
      postgresql-client \
      tzdata && \
    rm -rf /var/lib/apt/lists/*

# Copy installed gems and app code from build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_DEPLOYMENT=1

# Create non-root user
RUN groupadd --system --gid 1000 rails && \
    useradd --system --uid 1000 --gid rails --shell /bin/bash --create-home rails && \
    chown -R rails:rails /rails
USER rails

# Entrypoint and default command
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 80
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]