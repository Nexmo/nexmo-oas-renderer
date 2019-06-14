FROM ruby:2.6
COPY . /
RUN gem install bundler
RUN bundle install
EXPOSE 4567
ENTRYPOINT ["bundle", "exec", "/exe/nexmo-oas-renderer"]
