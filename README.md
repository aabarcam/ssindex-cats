# ESTE README CORRESPONDE A LA VERSIÓN 1 DEL PROYECTO Y ESTA DESACTUALIZADO, REFERIRSE A LA ÚLTIMA VERSIÓN DEL [PROYECTO](https://github.com/aabarcam/ss-cat-facts) COMPLETO

# Instrucciones de ejecución

## Docker

### Ambiente de desarrollo

Para construir el proyecto con docker es necesario tener instalado [Docker Compose](https://docs.docker.com/compose/install/), y basta con ejecutar el comando:

```
docker compose up
```

Esto construye la imagen de Docker de ser necesario, y levanta el contenedor con el proyecto en marcha. Finalmente, se debiese poder acceder a la aplicación web localmente en el puerto 3000. (http://localhost:3000)

### Tests

Para ejecutar los tests existentes, basta con abrir una consola en el contenedor en ejecución, por ejemplo con el comando:

```
docker exec -ti <nombre-contenedor> /bin/bash
```

Y en esta ejecutar el comando:

```
bin/rails test
```

## Docker Dev Container

Se añaden tambien archivos .devcontainer que permiten utilizar Visual Studio Code para desarrollar el proyecto dentro del contenedor en ejecución con las siguientes [instrucciones](https://code.visualstudio.com/docs/devcontainers/containers).

## Sin Docker

### Requisitos

* Ruby v3.4.4
* Ruby on rails v8.0.2

### Instrucciones

En el directorio base del proyecto ejecutar en una consola:

```
bundle install

bin/rails db:migrate
```

Esto instala todas las dependencias del proyecto y ejecuta las migraciones de la base de datos.

### Ambiente de desarrollo

Para levantar el ambiente de desarrollo, en el directorio base del proyecto ejecutar en una consola:

```
bin/rails server
```

El servidor entonces queda disponible localmente en el puerto 3000 y es accesible desde http://localhost:3000.

### Tests

Para ejecutar los tests existentes, en el directorio base del proyecto ejecutar en una consola:

```
bin/rails test
```

# Desiciones de diseño

## PMV

Se comenzó el desarrollo teniendo en cuenta el plazo límite de entrega, con lo cual se apunta a alcanzar un producto mínimo viable que cumpla con los requisitos pedidos, y luego extender el proyecto con los requerimientos menos escenciales.

Se escoje Ruby on Rails como el framework MVC a utilizar durante el desarrollo, y para alcanzar el PMV, se hará uso de las views de Rails para renderizar en el navegador.

## Service objects

Se utiliza el patrón de diseño Service Objects para extraer la funcionalidad que se comunica con la API externa CatFacts del controlador, creando un servicio que se encague de aquella lógica.

## Relación usuario y cat fact

Dado que no se quiere copiar toda la API de CatFacts en la base de datos del proyecto, se necesita una manera de relacionar un usuario con los CatFacts que le gustan. Se añade una tabla ```user_likes_cat_fact```, que actúa como relación de asociación entre la tabla de usuarios y los CatFacts, como si estos fueran parte de otra tabla de la base de datos del proyecto. Esta tabla ```user_likes_cat_fact``` mapea usuarios a CatFacts utilizando el ID del usuario como una llave foránea, y una ID asignada a cada CatFact según la página en que se encuentra y su posición en ella. De esta manera, si alguna vez cambiara el formato de paginación de la API de CatFacts, los 'me gusta' de los usuarios debiesen seguir siendo los correctos.

Dado que CatFacts entrega el listado en varias páginas, para enseñar los CatFacts más populares, se decide enseñar los 10 con más me gusta y se busca en que página está cada uno según su ID. De esta manera se hacen a lo más 10 llamadas a la API externa, en lugar de 34 (páginas que hay actualmente) para obtener la totalidad de los CatFacts.

# Conexión API Cat Facts

Para simplificar un poco las llamadas a API externas se añade la Gem httparty. Se tomaron en cuenta otras alternativas como Faraday que ofrece mayor flexibilidad, pero dado el alcance del proyecto, se consideró que sería sobreingeniería de la solución.

# Testing

Para realizar testing de las llamadas a API externas hacia CatFacts, se añade la Gem Webmock al proyecto. Esta cual permite crear stubs que actuén en lugar de las llamadas http y así ejecutar los tests sin necesidad de conexión a internet ni dependiendo de la disponibilidad de la API de CatFacts.

# Control de versiones

Se mantiene el código en este repositorio de github, siguiendo la convención de ramas de [Git Flow](https://danielkummer.github.io/git-flow-cheatsheet/index.es_ES.html). Adicionalmente, el mensaje de cada commit intenta seguir las convenciones descritas en [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) para mantener la claridad.
