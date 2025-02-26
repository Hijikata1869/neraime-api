FROM ruby:3.2.5-bullseye
RUN apt-get update -qq
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && apt-get install -y nodejs
RUN npm install -g yarn

WORKDIR /neraime_api
COPY . /neraime_api/
RUN bundle install --path vendor/bundle
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3001"]
