# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Requisitos del sistema

...

# Instrucciones

## Preparación

En el directorio base del proyecto ejecutar en una consola:

```bundle install```

para instalar todas las dependencias del proyecto.

## Servidor de desarrollo

Para levantar el ambiente de desarrollo, en el directorio base del proyecto ejecutar en una consola:

```bin/rails server```

El servidor entonces escuchará al puerto 3000 y es accesible desde ```localhost:3000```.

## Tests

Para ejecutar los tests existentes, en el directorio base del proyecto ejecutar en una consola:

```bin/rails test test```

# Desiciones de diseño

## PMV

Se comenzó el desarrollo teniendo en cuenta el plazo límite de entrega, con lo cual se apunta a alcanzar un producto mínimo viable que cumpla con los requisitos pedidos, y luego extender el proyecto con los requerimientos menos escenciales.

Se escoje Ruby on Rails como el framework MVC a utilizar durante el desarrollo, y para alcanzar el PMV, se hará uso de las views de Rails para renderizar en el navegador.

# Conexión API Cat Facts

Para simplificar un poco las llamadas a API externas se añade la Gem httparty. Se tomaron en cuenta otras alternativas como Faraday que ofrece mayor flexibilidad, pero dado el alcance del proyecto, se consideró que sería sobreingeniería de la solución.

# Testing

Para realizar testing de las llamadas a API externas hacia CatFacts, se añade la Gem Webmock al proyecto. Esta cual permite crear stubs que actuén en lugar de las llamadas http y así ejecutar los tests sin necesidad de conexión a internet ni dependiendo de la disponibilidad de la API de CatFacts.