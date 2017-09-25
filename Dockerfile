FROM ruby:2.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir -p /usr/src/mbta-statistics
WORKDIR /usr/src/mbta-statistics

COPY Gemfile /usr/src/mbta-statistics/
COPY Gemfile.lock /usr/src/mbta-statistics/
RUN bundle install

COPY . /usr/src/mbta-statistics

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]