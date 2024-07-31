# Dockerfile

FROM ruby:3.3.0

# Install system dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# Set the working directory
WORKDIR /usr/src/app

# Copy Gemfile and Gemfile.lock into the container
COPY Gemfile* ./

# Install necessary gems
RUN gem install bundler:2.3.3
RUN bundle install

# Copy the rest of the application into the container
COPY . .

# Expose the port
EXPOSE 3000

# Start command
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && rails s -b '0.0.0.0'"]
