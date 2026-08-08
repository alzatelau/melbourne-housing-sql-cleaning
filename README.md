
# Melbourne Housing Market — SQL Data Cleaning & Transformation

##  Resumen del Proyecto

Este proyecto aborda el proceso completo de **limpieza, estandarización e imputación de datos** sobre un conjunto de datos real y de gran volumen (~34,000 registros) del mercado inmobiliario en Melbourne, Australia. 

El objetivo principal fue transformar un dataset crudo e inconsistente en una fuente de datos confiable y optimizada para análisis exploratorio (EDA) o modelado predictivo de precios.

---

## Principales Habilidades y Técnicas Aplicadas

* **Arquitectura de Staging Tables:** Uso estricto de tablas temporales/copias para preservar los datos originales (`RAW`) y garantizar la trazabilidad de las transformaciones.
* **Deduplicación Avanzada:** Aplicación de funciones de ventana (`ROW_NUMBER()` con partición en 21 atributos) para identificar e imputar registros duplicados.
* **Análisis Investigativo de Negocio:** Análisis de causa raíz sobre datos faltantes. Se identificó que el 99% de los nulos en variables físicas (`Bedroom2`, `Bathroom`, `Landsize`, `BuildingArea`) correspondían a registros de la región *Metropolitan* entre 2016 y 2018.
* **Estandarización de Datos Categóricos:** Unificación de más de 12 inconsistencias tipográficas en nombres de agencias inmobiliarias (`SellerG`), logrando coherencia en la entidad.
* **Imputación Contextual:** Relleno de datos geográficos faltantes (`CouncilArea`, `Regionname`) mediante inferencia basada en la columna `Suburb`.
* **Casting y Optimización de Esquema:** Conversión de tipos de datos genéricos (`TEXT`) a tipos específicos optimizados (`INT`, `FLOAT`, `DATE`).

---

## Flujo de Trabajo de Limpieza (Paso a Paso)

1. **Ingesta y Staging:** Carga masiva de datos mediante `LOAD DATA LOCAL INFILE` y creación de la tabla de trabajo `houses_staging`.
2. **Deduplicación:** Asignación de índices únicos por grupo para eliminar filas duplicadas en `houses_staging2`.
3. **Limpieza de Cadenas:** Eliminación de espacios en blanco al inicio y final con `TRIM()`.
4. **Homogeneización de Entidades:** Unificación de variantes de nombres comercialmente equivalentes (ej. `Prof.` / `Professional` $\rightarrow$ `Prof`, `R&H` $\rightarrow$ `Raine&Horne`, `M.J` $\rightarrow$ `MJ`).
5. **Corrección de Valores Nulos y Formatos de Fecha:** Conversión de cadenas vacías y `#N/A` a `NULL` reales y parseo de fechas con `STR_TO_DATE()`.
6. **Validación de Outliers:** Detección y tratamiento de anomalías en variables numéricas (ej. reemplazo de `YearBuilt = 1196` por `NULL`).

---
