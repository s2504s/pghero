FROM ruby:3.1.4

MAINTAINER Andrew Kane <andrew@ankane.org>

ARG INSTALL_PATH=/app
ARG RAILS_ENV=production
ARG DATABASE_URL=postgresql://user:pass@127.0.0.1/dbname
ARG SECRET_TOKEN=dummytoken

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY . .

RUN apt-get clean \
    && apt-get update -y \
    && apt-get install -y build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler && \
    bundle install && \
    bundle binstubs --all && \
    bundle exec rake assets:precompile && \
    rm -rf tmp && \

ENV PORT 8080

EXPOSE 8080

CMD puma -C /app/config/puma.rb
