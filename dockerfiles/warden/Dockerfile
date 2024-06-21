FROM ruby:3.3.3-alpine
ENV RACK_ENV=production
ENV GITHUB_WARDEN_SECRET_TOKEN=''
ENV GITHUB_WARDEN_BUGZILLA_API_KEY=''
RUN mkdir /testing-github-warden
WORKDIR /testing-github-warden
ADD . /testing-github-warden
RUN apk add build-base
RUN gem update bundler
RUN bundle config set without 'test development executioner' && bundle install
CMD puma -C config/puma.rb
