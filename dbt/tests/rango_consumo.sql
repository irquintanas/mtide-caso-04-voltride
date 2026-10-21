-- bateria_pct tiene que estar en un rango creíble para este negocio (1.75 a 38.2).
select trayecto, bateria_pct from {{ ref('stg_parte') }}
where bateria_pct not between 1.75 and 38.2
