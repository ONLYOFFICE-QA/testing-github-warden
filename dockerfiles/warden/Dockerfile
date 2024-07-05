FROM ruby:3.3.3-alpine
ENV RACK_ENV=production
ENV SECRET_TOKEN=''
ENV BUGZILLA_API_KEY=''
RUN mkdir /testing-github-warden
WORKDIR /testing-github-warden
COPY . /testing-github-warden
RUN apk --no-cache add build-base
RUN gem update bundler && \
    bundle config set without 'test development executioner' && \
    bundle install
CMD ["puma", "-C", "config/puma.rb"]

