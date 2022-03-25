FROM ruby:3.1.1-alpine
ENV RACK_ENV=production
ENV SECRET_TOKEN=''
ENV BUGZILLA_API_KEY=''
RUN mkdir /testing-github-warden
WORKDIR /testing-github-warden
ADD . /testing-github-warden
RUN gem update bundler
RUN bundle config set without 'test development warden' && bundle install
