[![Houlak: We develop first-class apps](https://houlak.com/assets/images/logos/hk-logo-color.svg)](https://houlak.com)

[![Twitter](https://img.shields.io/badge/twitter-@houlakdev-blue.svg?style=flat-square)](https://twitter.com/houlakdev)

# Houlak Take-Home App Project

## Propuesta

Utilizando la [API de Spotify](https://developer.spotify.com/documentation/web-api/), se deberá crear una app que permita buscar y listar artistas, ver información relevante de los mismos y listar sus canciones más escuchadas. 

## Implementación
### Listado de artistas
Esta pantalla debe:
 - Mostrar un empty state de Bievenida y un buscador.
 - Tener un buscador que permita buscar **únicamente** por artista.
 - Listar los artistas encontrados a partir de la búsqueda, ordenando por **mayor popularidad primero**. Se debe de mostrar al menos una foto y el nombre del artista.
 - Permitir seleccionar/ir al detalle de un artista del listado.

### Detalle de un Artista
Esta pantalla debe:
- Mostrar **información del artista relevante**. Por ejemplo: Foto de cubierta, nombre, género musical.
- Listar las primeras **5 canciones más escuchadas**.

## API
Algunos servicios que te podrían servir:

| Servicio | Link |
| ------ | ------ |
| Get search item | https://developer.spotify.com/console/get-search-item |
| Get artist | https://developer.spotify.com/console/get-artist|
| Get artist top tracks | https://developer.spotify.com/console/get-artist-top-tracks |

## Notas
- Se valorará el buen uso de git (commits, branches, etc.)
- Se pueden utilizar librerías de terceros
- Se valorará funcionalides extras agregadas
