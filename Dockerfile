# Dockerfile

FROM ruby:3.3.0

# Instala dependencias del sistema
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# Configura el directorio de trabajo
WORKDIR /usr/src/app

# Copia el archivo Gemfile y Gemfile.lock al contenedor
COPY Gemfile* ./

# Instala las gemas necesarias
RUN gem install bundler:2.3.3
RUN bundle install

# Copia el resto de la aplicación al contenedor
COPY . .

# Exponer el puerto
EXPOSE 3000

# Comando de inicio
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && rails s -b '0.0.0.0'"]
