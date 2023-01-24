# Proyecto Ingenieria Web
## Por: José I. Escudero

## Servicios requeridos
+ Postgres

## Configuración
### Ruby
Hay varias formas de instalar Ruby en el sistema. Se recomienda usar un administrador de versiones de Ruby como RVM, rbenv, chruby, asdf, etc.
Encontrará la versión de Ruby requerida en `.ruby-version`.

### Bundler
Bundler es una manera de prevenir el infierno de dependencias y garantiza que los gems que se necesitan estén presentes en el ambiente de desarrollo, de pruebas y la producción.
Para instalarlo ejecute: `gem install bundler -v 2.2.26`

### Instalar dependencias
* Simplemente ejecute `bundle`

### Base de datos
Se puede crear una base de datos nueva (vacía) con los siguientes comandos:
* Crear base de datos: `rails db:setup`

Recuerda ejecutar las migraciones ejecutando `rails db:migrate` 

## ¿Como ejecutar el proyecto?

* Rails server: `rails s`

## Migraciones

* Generar migratción: `rails generate migration <name>`
* Ejecutar migración: `rails db:migrate`

(https://guides.rubyonrails.org/active_record_migrations.html)

## Comandos útiles
* Listar endpoints: `rails routes`
* Rails console: `rails c`
* Rubocop (style check): `rubocop -a`