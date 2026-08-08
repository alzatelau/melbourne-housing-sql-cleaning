
# Melbourne Housing Market — SQL Data Cleaning & Transformation

## Descripción del proyecto
Este proyecto consiste en un proceso completo de limpieza, estandarización y preparación de datos aplicado al dataset público Melbourne Housing Full (más de 34,000 registros de propiedades vendidas en Melbourne, Australia), utilizando MySQL como motor de base de datos.

El objetivo fue transformar un dataset crudo, inconsistente y con múltiples problemas de calidad, en una tabla lista para análisis y modelado (por ejemplo, predicción de precios), aplicando buenas prácticas de ingeniería de datos: control de duplicados, normalización de categorías, manejo de valores nulos, tipado correcto de columnas y detección de valores atípicos.

Todo el proceso está documentado paso a paso en el script SQL, incluyendo el razonamiento detrás de cada decisión (qué se corrige, qué se elimina, qué se deja igual y por qué)
---

## Objetivo
Transformar el dataset crudo e inconsistente en una fuente de datos confiable y optimizada para análisis exploratorio (EDA) o modelado predictivo de precios.

---
## Tecnologías utilizadas

* **MySQL (Workbench)
* **SQL estándar: CTE (WITH), WINDOW FUNCTIONS (ROW_NUMBER), funciones de agregación (COUNT, GROUP BY)
* **Carga de datos masivos con LOAD DATA LOCAL INFILE
---
## Proceso de limpieza

### 1. Carga y respaldo de datos

* **Creación de una tabla origen (melbourne_housing_full2) con todas las columnas como TEXT, para evitar errores de carga por formato.
* **Carga masiva del CSV con LOAD DATA LOCAL INFILE.
* **Creación de una tabla de trabajo (houses_staging) como copia, dejando la tabla original intacta como respaldo — buena práctica para no perder la fuente cruda.

### 2. Eliminación de duplicados
* **Uso de ROW_NUMBER() OVER (PARTITION BY ...) sobre todas las columnas relevantes para identificar registros 100% duplicados.
* **Eliminación segura mediante una tabla intermedia (houses_staging2), ya que MySQL no permite DELETE directo sobre resultados de funciones de ventana.

### 3. Estandarización de texto
* **TRIM() en todas las columnas de tipo texto para eliminar espacios al inicio/final.
* **Normalización de la columna SellerG (agencias inmobiliarias): se detectaron decenas de variantes del mismo nombre de agencia (ej. William vs Williams, PRD vs PRDNationwide, MJ vs M.J, Prof vs Professional). Cada caso se validó cruzando Suburb, Regionname y CouncilArea antes de unificar, y se descartó la unificación cuando no había evidencia suficiente (ej. Collings vs Collins, Black vs Blackbird se mantuvieron separadas por ser agencias distintas).

### 4. Manejo de valores nulos y códigos faltantes
* **Conversión de valores '#N/A' a NULL reales en Regionname y CouncilArea.
* **Análisis exploratorio antes de actuar: se investigó un patrón donde ~6,400 filas tenían vacías simultáneamente Bedroom2, Bathroom, Car, Landsize, BuildingArea y YearBuilt. Se identificó que el patrón se concentraba en la región Metropolitan (2016–2018), lo que sugiere un problema sistemático de captura de datos, no un error aleatorio — y se documentó como tal antes de convertir esos campos a NULL.
* **Recuperación de CouncilArea y Regionname faltantes mediante búsqueda cruzada por Suburb (cuando el mismo suburbio tenía el dato en otras filas).
* **Eliminación justificada de las ~7,600 filas sin Price, dado que el análisis se enfoca en predicción de precios y esas filas no aportan valor al objetivo del proyecto

### 5. Conversión de tipos de datos
* **Conversión de Date (texto) a tipo DATE real con STR_TO_DATE.
* **Conversión de columnas numéricas (Price, Rooms, Distance, Landsize, BuildingArea, Bathroom, Bedroom2, Car) de TEXT a INT/FLOAT, previa limpieza de vacíos a NULL.

### 6. Detección de valores atípicos (outliers)
* **Verificación de precios inválidos (Price <= 0), habitaciones en cero y terrenos negativos.
* **Identificación de un año de construcción imposible (YearBuilt = 1196) y corrección a NULL en lugar de eliminarlo silenciosamente.

### 7. Optimización final del esquema
* **Eliminación de columnas redundantes (Lattitude, Longtitude, ya cubiertas por Distance) y de columnas auxiliares (row_num) que solo se usaron durante el proceso.
* **Verificación final de conteo de filas y estructura (DESCRIBE)

##Habilidades demostradas

* **Diseño de pipelines de limpieza de datos reproducibles en SQL puro
* **Uso de funciones de ventana (ROW_NUMBER) y CTEs para deduplicación
* **Toma de decisiones basada en evidencia (no eliminar/unificar datos sin verificar el contexto)
* **Manejo de datos faltantes distinguiendo entre "vacío por error" y "vacío sistemático"
* **Conversión y validación de tipos de datos
* **Documentación clara del razonamiento en cada paso, no solo del código
---
## Estructura del repositorio

```
├── melbourne_housing_cleaning.sql   # Script completo de limpieza
├── Melbourne_housing_FULL.csv       # Dataset original (fuente)
└── README.md                        # Este documento
```
