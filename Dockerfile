FROM ruby:3.4.1-slim AS build
WORKDIR /rails
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential libpq-dev git curl tzdata
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install
COPY . .

FROM ruby:3.4.1-slim
WORKDIR /rails
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y libpq5 postgresql-client tzdata && \
    rm -rf /var/lib/apt/lists/*
COPY --from=build /rails /rails
ENV PORT=3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
