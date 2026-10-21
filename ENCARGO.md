# Caso 04 · VoltRide — el encargo

> Negocio y datos **ficticios**, creados para la asignatura. Es tu mismo caso de la J3.

## Qué ha pasado desde la J3

En la J3 limpiaste el parte en un cuaderno y contestaste tres preguntas. VoltRide quiere su parte de trayectos automatizado y, con el registro de alquileres de la app, decidir **dónde poner más plazas de aparcamiento**.

Ahora conviertes aquel cuaderno en un **lakehouse** de verdad, en tu propio repositorio, y publicas un **portal** que
cuenta lo que has hecho. Cómo preparar el repositorio y el ciclo de trabajo de cada bloque: [README.md](README.md).

## Lo que tienes al empezar

- En bronce, el parte de la J3: `lakehouse/bronce/parte/fecha_carga=2026-04-24/`.
- En `dbt/models/plata/stg_parte.sql`, la limpieza que hiciste en la J3, con unos tests básicos (`_plata.yml`, `dbt/tests/`).
- `dbt build` en verde. La capa oro, vacía: la construyes tú.
- En `paginas/`, las cuatro páginas del portal que escribirás, cada una con un guion de lo que debe contar.

**Bronce no se toca nunca**: todo arreglo va en plata.

---

## Bloque 1 · La remesa nueva · rama `remesa`

1. `python herramientas/sistema_simulado.py remesa`: llega una entrega nueva del parte en `bronce/parte/fecha_carga=2026-05-04/` (unos diez días más de trayectos).
2. `dbt build --project-dir dbt --profiles-dir dbt`. A mitad de la remesa se actualizó el firmware de los patinetes. Mira qué test se queja y a partir de qué fecha.
3. Arregla `dbt/models/plata/stg_parte.sql` hasta que `dbt build` quede en verde y el problema esté resuelto (no siempre hay un test que lo grite: a veces tienes que escribirlo tú). Deja un comentario en el SQL: **qué** venía mal y **por qué** lo arreglas así.
4. Escribe `paginas/1-remesa.md`.
5. Pull request en tu repositorio, Actions en verde y lo fusionas.

## Bloque 2 · El oro · rama `oro`

Crea en `dbt/models/oro/` estos modelos, **con estos nombres exactos** (el portal y la jornada de Visualización los leen así):

| Modelo | Qué tiene |
|---|---|
| `dim_usuario` | una fila por cada valor distinto de `usuario` |
| `dim_patinete` | una fila por cada valor distinto de `patinete` |
| `dim_zona` | una fila por cada valor distinto de `zona` |
| `fact_trayectos` | un trayecto por fila: `trayecto`, `fecha`, `usuario`, `patinete`, `zona`, `minutos`, `bateria_pct`, `importe_eur`, `con_incidencia` |
| `pregunta_1` | ¿Qué **zona** deja menos ingreso por minuto de trayecto? Una fila por `zona`, con `zona` en la primera columna y `ingreso_min` (€/min), de menor a mayor |
| `pregunta_2` | ¿Qué **usuario** gasta más batería por minuto? Una fila por `usuario`, con `usuario` en la primera columna y `bateria_10min` (% de batería cada 10 min), de mayor a menor |
| `pregunta_3` | ¿Qué **patinete** acumula más incidencias por cada 100 minutos de uso? Una fila por `patinete`, con `patinete` en la primera columna y `incidencias_100min` (incidencias por 100 min), de mayor a menor |

En un `_oro.yml`, sus tests: en las dimensiones, `unique` y `not_null`; en el hecho, `unique` en `trayecto` y `relationships` con cada dimensión.

Escribe `paginas/2-oro.md`: tu estrella y las tres respuestas. Con la remesa nueva (un 25 % más de datos), ¿siguen saliendo las mismas que en la J3? Pull request, verde, fusionas.

## Bloque 3 · Fuentes nuevas · rama `fuentes`

1. `python herramientas/sistema_simulado.py fuentes`: llegan estos ficheros a bronce y quedan declarados en `dbt/models/plata/_fuentes.yml`.

| Fichero | Qué es | Columnas |
|---|---|---|
| `bronce/aparcamientos/aparcamientos.csv` | plazas de aparcamiento que tiene cada zona | zona, plazas |
| `bronce/eventos/eventos_alquiler_2026-05-06.json` | La app exporta un registro con un evento `inicio` y uno `fin` por cada alquiler. | evento_id, alquiler_id, patinete, zona, tipo (inicio / fin), ts |

2. **El giro.** Los patinetes mandan cada evento **«al menos una vez»**: si no reciben confirmación, lo reenvían. En el registro hay eventos **repetidos con el mismo `evento_id`**, sobre todo de una zona con mala cobertura.
3. Modelos de plata: `stg_aparcamientos` y `stg_eventos` (el registro lo lees con `source('bronce', 'eventos')`).
4. **Test protagonista.** **Cada evento cuenta una sola vez**: `evento_id` es único en `stg_eventos`. Ponle el test genérico `unique` y comprueba que sin deduplicar se pone rojo.
5. **Pregunta 4** (`dbt/models/oro/pregunta_4.sql`): ¿En qué zona se piden **más alquileres por cada plaza de aparcamiento**? Cuidado: la zona con más alquileres no tiene por qué ser la respuesta.
6. Escribe `paginas/3-fuentes.md`. Pull request, verde, fusionas.

## Bloque 4 · El memo · rama `memo`

Escribe `paginas/memo.md`: el memo para la dirección de VoltRide, con las cuatro respuestas citadas con marcas. La comprobación exige que existan `pregunta_1` a `pregunta_4`. Repasa el portal entero antes de fusionar.

---

## Lo que se entrega

- Tu repositorio en tu cuenta, con los cuatro pull requests fusionados y la última ejecución de `main` en verde.
- Tu portal publicado, con sus cuatro páginas escritas, y tu `dbt-docs`.
- La presentación oral (5 minutos): con tu portal en pantalla, el problema de calidad, tu test protagonista, las cuatro respuestas y tu recomendación.
