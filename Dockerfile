# syntax=docker/dockerfile:1

# set Ruby version
ARG RUBY_VERSION=3.4.4
FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS base

# Rails app live folder
WORKDIR /rails

# Base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl build-essential libyaml-dev libjemalloc2 git tzdata postgresql-client && \
    rm -rf /var/lib/apt/lists/ /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle"

# Go to build stage
FROM base AS build

# Install what's needed to build the gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config && \
    rm -rf /var/lib/apt/lists/ var/cache/apt/archives
    

# Install app gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git
    # bundle exec bootsnap precompile --gemfile

# Copy the app code to the container
COPY . .

# Precompile bootsnap to go faster!
# RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets
# RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage
FROM base

# Copy from build to base
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run runtime files as non-root (security)
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint
ENTRYPOINT [ "/rails/bin/docker-entrypoint" ]

# Start server
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]
