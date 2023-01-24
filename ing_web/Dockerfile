  FROM ruby:3.1.1
  RUN mkdir -p /usr/src/app
  WORKDIR /usr/src/app
  RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client
  ENV RAILS_LOG_TO_STDOUT true
  COPY Gemfile /usr/src/app/
  COPY Gemfile.lock /usr/src/app/
  RUN bundle config --global frozen 1
  RUN bundle config set --local without 'development test'
  RUN bundle install
  COPY . /usr/src/app
  EXPOSE 3000
  CMD ["rails", "server", "-b", "0.0.0.0"]