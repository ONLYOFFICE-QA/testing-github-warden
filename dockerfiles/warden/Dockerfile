FROM ruby:3.2.1-alpine
ENV RACK_ENV=production
ENV SECRET_TOKEN=''
ENV BUGZILLA_API_KEY=''
RUN mkdir /testing-github-warden
WORKDIR /testing-github-warden
ADD . /testing-github-warden
RUN apk add build-base
RUN gem update bundler
RUN bundle config set without 'test development executioner' && bundle install
CMD puma -C config/puma.rb
