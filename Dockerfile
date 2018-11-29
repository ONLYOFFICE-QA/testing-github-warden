FROM ruby:2.4.1
ENV RACK_ENV=production
RUN mkdir /testing-github-warden
WORKDIR /testing-github-warden
ADD . /testing-github-warden
RUN bundle install --without test development
CMD puma -C config/puma.rb