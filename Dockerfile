FROM ruby:2.3.5-alpine

RUN apk add --no-cache \
  ruby \
  nodejs \
  postgresql-client \
  postgresql-dev \
  ca-certificates \
  ruby-dev \
  build-base \
  bash \
  linux-headers \
  zlib-dev \
  libxml2-dev \
  libxslt-dev \
  tzdata \
  && rm -rf /var/cache/apk/*

RUN mkdir -p /app /bin /app/config
WORKDIR /app

RUN gem update --system 2.6.10

ADD https://github.com/bundler/bundler-api/raw/master/versions.list /app/config/versions.list

COPY . /app

RUN gem install bundler io-console --no-ri --no-rdoc && bundle install --jobs 20 --retry 5 --without deploy

RUN RAILS_ENV=production bin/rails assets:precompile

EXPOSE 3001

ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server", "-b", "0.0.0.0"]
