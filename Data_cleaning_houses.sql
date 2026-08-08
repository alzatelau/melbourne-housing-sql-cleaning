#Data cleaning 
select*
from melbourne_housing_full;

#Creo una tabla apartir de esa primera que no se logro cargar del todo
#Esta va hacer mi tabla de datos original 
CREATE TABLE `melbourne_housing_full2` (
  `Suburb` text,
  `Address` text,
  `Rooms` text,
  `Type` text,
  `Price` text,
  `Method` text,
  `SellerG` text,
  `Date` text,
  `Distance` text,
  `Postcode` text,
  `Bedroom2` text,
  `Bathroom` text,
  `Car` text,
  `Landsize` text,
  `BuildingArea` text,
  `YearBuilt` text,
  `CouncilArea` text,
  `Lattitude` text,
  `Longtitude` text,
  `Regionname` text,
  `Propertycount` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

#Cargue la informacion desde mi equipo a esa tabla , ya que es un dataset muy grande 
USE melbourn_houses;

LOAD DATA LOCAL INFILE 'C:/Users/Usuario/OneDrive/Desktop/Analisis de datos/Proyectos analisis de datos/Melbourne_housing_FULL.csv'
INTO TABLE melbourne_housing_full2
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

select *
from melbourne_housing_full2;
#Ya tengo mi tabla con los datos 

#Voy a crear una copia de la tabla para trabajar con ella 
create table houses_staging
like melbourne_housing_full2;

insert into houses_staging
select *
from melbourne_housing_full2;
#Verificamos que si tengan la misma cantidad de datos 
select count(*) 
from melbourne_housing_full2;

select count(*) 
from houses_staging;

#Miro duplicados 
select*,
row_number() over(partition by Suburb,Address,Rooms,`Type`, Price,Method,SellerG,
`Date`, Distance, Postcode, Bedroom2,Bathroom,Car,Landsize,BuildingArea,YearBuilt,
CouncilArea,Lattitude,Longtitude,Regionname,Propertycount) as row_num
from houses_staging;

#para filtrar
with filtrar_duplicados as
(
select*,
row_number() over(partition by Suburb,Address,Rooms,`Type`, Price,Method,SellerG,
`Date`, Distance, Postcode, Bedroom2,Bathroom,Car,Landsize,BuildingArea,YearBuilt,
CouncilArea,Lattitude,Longtitude,Regionname,Propertycount) as row_num
from houses_staging
)
select*
from filtrar_duplicados
where row_num <2;
#Ahi ya no abrian duplicados , lo siguiente es mantener mi tabla sin duplicados 
#Entonces los debo eliminar 

#Para eliminarlos debo crear una nueva tabla 
CREATE TABLE `houses_staging2` (
  `Suburb` text,
  `Address` text,
  `Rooms` text,
  `Type` text,
  `Price` text,
  `Method` text,
  `SellerG` text,
  `Date` text,
  `Distance` text,
  `Postcode` text,
  `Bedroom2` text,
  `Bathroom` text,
  `Car` text,
  `Landsize` text,
  `BuildingArea` text,
  `YearBuilt` text,
  `CouncilArea` text,
  `Lattitude` text,
  `Longtitude` text,
  `Regionname` text,
  `Propertycount` text,
  `row_num` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

#Es una tabla vacia por lo tanto debo insertar informacion
#Inserto la informacion organizada 

insert into houses_staging2
select*,
row_number() over(partition by Suburb,Address,Rooms,`Type`, Price,Method,SellerG,
`Date`, Distance, Postcode, Bedroom2,Bathroom,Car,Landsize,BuildingArea,YearBuilt,
CouncilArea,Lattitude,Longtitude,Regionname,Propertycount) as row_num
from houses_staging;

select*
from houses_staging2;
#Elimino los datos
delete
from houses_staging2
where row_num >1;
#Esta en mi nueva tabla sin duplicados 
select count(*) 
from houses_staging2;

select count(*)#34857
from houses_staging;
#solo se elimino una fila 

select *
from houses_staging2;
#trim eliminar espacios inicio y final 
update houses_staging2
set
   Suburb = trim(Suburb),
   Address = trim(Address),
   Price = trim(Price),
   Method= trim(Method),
   SellerG = trim(SellerG),
   `Date` = trim(`Date`), 
   Landsize = trim(Landsize),
   BuildingArea = trim(BuildingArea),
   YearBuilt = trim(YearBuilt),
   CouncilArea = trim(CouncilArea),
   Regionname = trim(Regionname),
   Propertycount = trim(Propertycount);

select *
from houses_staging2;

select distinct SellerG 
from houses_staging2
order by 1;
#Veo algo como William y Williams 
select distinct SellerG
from houses_staging2
where SellerG like 'William%';
select SellerG , Suburb ,Regionname,CouncilArea
from houses_staging2
where SellerG like 'William%';
#Son la misma por que ambas estan en la misma Region name y CouncilArea 
update houses_staging2
set SellerG = 'Williams'
where SellerG like 'William%';

#Red y Redina
select distinct SellerG
from houses_staging2
where SellerG  like 'Red%';

select SellerG , Suburb ,Regionname,CouncilArea
from houses_staging2
where SellerG like 'Red%';
#No hay coincidencias en los datos para decir que son la misma agencia 

#Property y Propertyau es la misma. Ademas  Propertyau solo esta una vez 
select distinct SellerG
from houses_staging2
where SellerG  like 'Property%';

select SellerG , Suburb ,Regionname,CouncilArea
from houses_staging2
where SellerG like 'Property%';

update houses_staging2
set SellerG = 'Property'
where SellerG like 'Property%';

#PRD y PRDNationwide 
select distinct SellerG
from houses_staging2
where SellerG  like 'PRD%';

select SellerG , Suburb ,Regionname,CouncilArea
from houses_staging2
where SellerG like 'PRD%';

#solo hay un PRD las voy a unificar 
update houses_staging2
set SellerG = 'PRD'
where SellerG like 'PRD%';

#McGrath y McGrath% 
select distinct SellerG
from houses_staging2
where SellerG  like 'McGrath%';

update houses_staging2
set SellerG = 'McGrath'
where SellerG like 'McGrath%';

#LJ y LJH
select distinct SellerG
from houses_staging2
where SellerG  like 'LJ%';

select SellerG , Suburb ,Regionname,CouncilArea
from houses_staging2
where SellerG like 'LJ%';

update houses_staging2
set SellerG = 'LJ'
where SellerG like 'LJ%';

#Home y Homes
select distinct SellerG
from houses_staging2
where SellerG  like 'Home%';

select SellerG , Suburb , `Date`
from houses_staging2
where SellerG like 'Home%';
#No hay suficiente informacion para unificarlas

#Collings y Collins
select distinct SellerG
from houses_staging2
where SellerG like 'Collin%s';

select SellerG , Suburb , `Date`
from houses_staging2
where SellerG like 'Collin%s';

select count(*) 
from houses_staging2
where SellerG like 'Collings';

select count(*) 
from houses_staging2
where SellerG like 'Collins';
#comparten muchas similitudes pero son Agencias direfentes 

select distinct SellerG
from houses_staging2
where SellerG like 'Black%';
#Con esto se comprueba que Black y Blackbird son diferentes 
select SellerG , Suburb , `Date`
from houses_staging2
where SellerG like 'Black%';


select distinct SellerG
from houses_staging2
where SellerG like 'M%J';
#quiero mirar si MJ y M.J son los mismos 
select SellerG , Suburb , `Date`
from houses_staging2
where SellerG like 'M%J';
#Estas  dos empresas venden en los mismo barrios lo cual da una idea de que es la misma 
#por lo tanto es bueno estandarizar 
update houses_staging2
set SellerG = 'MJ'
where SellerG like 'M%J';

#verifico que filas voy impactar
select distinct SellerG
from houses_staging2
where SellerG like 'Prof%';

select distinct SellerG , Suburb, `Date`
from houses_staging2
where SellerG like 'Prof%';

select SellerG , Suburb , `Date`
from houses_staging2
where SellerG like 'Prof%';

select count(*) 
from houses_staging2
where SellerG like 'Prof.';

select count(*) 
from houses_staging2
where SellerG like 'Profess%';
#con esto concluimos que Professional problamente es la misma agencia que Prof.
#la organizamos 
update houses_staging2
set SellerG = 'Prof'
where SellerG like 'Prof%' ;

select distinct SellerG
from houses_staging2
where SellerG like 'Sweeney%';

update houses_staging2
set SellerG = 'Sweeney'
where SellerG like 'Sweeney%';

select distinct SellerG
from houses_staging2
where SellerG in('Raine','Raine&Horne', 'R&H') or SellerG like 'Raine%';

update houses_staging2
set SellerG = 'Raine&Horne'
where SellerG in('Raine','Raine&Horne', 'R&H') or SellerG like 'Raine%';


select distinct SellerG
from houses_staging2
where SellerG  like 'hockingstuart%';

update houses_staging2
set SellerG = 'Hockingstuart'
where SellerG like 'hockingstuart%';

select distinct SellerG
from houses_staging2
where SellerG  like 'Fletchers%';

update houses_staging2
set SellerG = 'Fletchers'
where SellerG like 'Fletchers%';

select distinct SellerG
from houses_staging2
where SellerG  like 'Buxton%';

update houses_staging2
set SellerG = 'Buxton'
where SellerG like 'Buxton%';
#Organize toda la columna de sellerG

#Sigo con  Region ,councilarea y suburb 
select distinct Regionname
from houses_staging2;

select Regionname
from houses_staging2
where Regionname  like '#N/A';

update houses_staging2
set Regionname = null
where Regionname  like '#N/A';


select distinct CouncilArea 
from houses_staging2
order by CouncilArea asc;

select CouncilArea 
from houses_staging2
where CouncilArea  like '#N/A';

update houses_staging2
set CouncilArea = null
where CouncilArea  like '#N/A';

select distinct Suburb
from houses_staging2;

select distinct `Type`
from houses_staging2;

select *
from houses_staging2;

#tengo 7609 que no tienen precio 
#Se eliminan las filas sin precio porque el análisis se enfoca en la
#predicción de precios sin este dato no aportan valor
select count(*)
from houses_staging2
where Price is null or Price = '';
 
delete 
from houses_staging2
where Price is null or Price = '';

#organizo la columna date ya que esta como texto 
SELECT `Date`,
STR_TO_DATE(`Date`, '%d/%m/%Y') as Formato_fecha
FROM houses_staging2;

#guardar cambios 
update  houses_staging2
set `Date` =STR_TO_DATE(`Date`, '%d/%m/%Y');
alter table houses_staging2 modify column Date DATE;

#Debo organizo la columna Price como int , Rooms , distance
#Bedroom2, Bathroom , Car 

#antes de convertir lo que este vacio lo debo convertir a null
select distinct(Rooms) # no tiene valores null o vacios 
from houses_staging2;

select distinct(Distance)#no tiene valores vacios ni null 
from houses_staging2;


select distinct(Bedroom2)#tiene valores vacios 
from houses_staging2
order by Bedroom2 asc ;

select count( *) #tiene 6441
from houses_staging2
where Bedroom2 = '';
#veo que comparte muchos valores nulls con Bedroom2 ,Bathroom,Car,Landsize,BuildingArea,YearBuil

select count( *) #tiene 6447
from houses_staging2
where Bathroom = '';

select * #tiene valores vacios  , la cantidad de filas que tiene esta condicion con 6435 muchas 
from houses_staging2
where Bedroom2 = ''
  and  Bathroom =''
  and Car = ''
  and Landsize = ''
  and BuildingArea = '' 
  and YearBuilt = '' ;
#Los valores que estan vacios representan los datos de la casa a nivel fisico 
#Para las preguntas que tengo no necesito estos datos , sin embargo estos datos pueden ser importantes
#cuando quiero analizar las areas construidas y hace cuanto se construyo la vivienda 

with columnas_vacias as
(
select * 
from houses_staging2
where Bedroom2 = ''
  and  Bathroom =''
  and Car = ''
  and Landsize = ''
  and BuildingArea = '' 
  and YearBuilt = '' 
)
select distinct(Suburb) #no veo ningun patron con Suburb
from columnas_vacias;

with columnas_vacias as
(
select * 
from houses_staging2
where Bedroom2 = ''
  and  Bathroom =''
  and Car = ''
  and Landsize = ''
  and BuildingArea = '' 
  and YearBuilt = '' 
)
select Regionname , count(*) as cantidad_vacios #La mayoria estan en Metropolitan
from columnas_vacias
group by Regionname 
order by cantidad_vacios desc;

with columnas_vacias as
(
select * 
from houses_staging2
where Bedroom2 = ''
  and  Bathroom =''
  and Car = ''
  and Landsize = ''
  and BuildingArea = '' 
  and YearBuilt = '' 
)
select count(*)  #6374 el problema esta en la region Metropolitan , no importa si es en el norte o en el sur 
from columnas_vacias
where Regionname like '%Metropolitan';

with columnas_vacias as
(
select * 
from houses_staging2
where Bedroom2 = ''
  and  Bathroom =''
  and Car = ''
  and Landsize = ''
  and BuildingArea = '' 
  and YearBuilt = '' 
)
select count(*) #El total de vacios es 6435 y de esos 6374 son de Metropolitan 
from columnas_vacias
where Regionname is not null or Regionname != '';

select count( *)#26819
from houses_staging2
where Regionname like '%Metropolitan';
# en la región Metropolitana no cuenta con la descripción
#física del inmueble (habitaciones, baños, estacionamientos, áreas)
#con base en esto quiero ver en que agencias estan 

with columnas_vacias as
(
select * 
from houses_staging2
where Bedroom2 = ''
  and  Bathroom =''
  and Car = ''
  and Landsize = ''
  and BuildingArea = '' 
  and YearBuilt = '' 
  and Regionname like '%Metropolitan'
)
select SellerG , count(*) as cantidad_vacios #no veo ningun patron con SellerG
from columnas_vacias
group by SellerG
order by cantidad_vacios  desc;
#el mas alto es la agencia Jellis 597


with columnas_vacias as
(
select * 
from houses_staging2
where Bedroom2 = ''
  and  Bathroom =''
  and Car = ''
  and Landsize = ''
  and BuildingArea = '' 
  and YearBuilt = '' 
)
select distinct(CouncilArea) #No hay nada atipico
from columnas_vacias;


with columnas_vacias as
(
select * 
from houses_staging2
where Bedroom2 = ''
  and  Bathroom =''
  and Car = ''
  and Landsize = ''
  and BuildingArea = '' 
  and YearBuilt = '' 
)
select distinct(`Date`) #No hay nada atipico
from columnas_vacias
order by `Date` asc; # las fechas estan del 2016 al 2018 
#con base en esto podriamos decir que en las regiones Metropolitan  
#2016-2018 no se registraron todos los datos de las descripciones fisica de la vivienda 

#lo que se puede hacer es convertir esas columnas en null 
select count(*) 
from houses_staging2
where Bedroom2 = ''
  and  Bathroom =''
  and Car = ''
  and Landsize = ''
  and BuildingArea = '' 
  and YearBuilt = '' ;
 
update houses_staging2
set 
  Bedroom2 = null,
  Bathroom = null,
  Car = null,
  Landsize = null,
  BuildingArea = null, 
  YearBuilt = null
where Bedroom2 = ''
  and  Bathroom =''
  and Car = ''
  and Landsize = ''
  and BuildingArea = '' 
  and YearBuilt = '';

select *
from houses_staging2;

#miro si los valores nulos que tengo definitivamente no tienen un valor o si 
select *
from houses_staging2
where CouncilArea is null or Regionname is null;
#Me aparece el Suburb de Camberwell , Fawkner Lot y Footscray 

select distinct( CouncilArea), Regionname
from houses_staging2
where Suburb = 'Camberwell'; 
#En council area me aparece la misma area para todo la cual es Boroondara City Council 
#y en Regionname Southern Metropolitan

update houses_staging2
set 
   CouncilArea = trim('Boroondara City Council'),
   Regionname = trim('Southern Metropolitan')
where Suburb = 'Camberwell'; 

select distinct( CouncilArea), Regionname
from houses_staging2
where Suburb like 'Fawkner%'; 

update houses_staging2
set 
   CouncilArea = trim('Hume City Council'),
   Regionname = trim('Northern Metropolitan')
where Suburb like 'Fawkner%'; 

select distinct( CouncilArea), Regionname
from houses_staging2
where Suburb like 'Footscray'; 

update houses_staging2
set 
   CouncilArea = trim('Maribyrnong City Council'),
   Regionname = trim('Western Metropolitan')
where Suburb like 'Footscray'; 

#ahora ya puedo convertir a int las columnas que deseo para esto es bueno confirmar que no tengan espacios vacios 
#ya que en la parte de arriba solo se modificaron algunos y no los de todas las filas 

select distinct(Price)
from houses_staging2
order by Price asc;
alter table houses_staging2 modify column Price int;

select distinct(Rooms)
from houses_staging2
order by Rooms asc;
alter table houses_staging2 modify column Rooms int;

select distinct(Distance)
from houses_staging2
order by Distance asc;

update houses_staging2
set Distance = null
where Distance like '#N/A';
alter table houses_staging2 modify column Distance float;

select distinct(Landsize)
from houses_staging2
order by Landsize asc;
alter table houses_staging2 modify column Landsize int;

select distinct(BuildingArea)
from houses_staging2
order by BuildingArea asc;
alter table houses_staging2 modify column BuildingArea int;

select distinct(Bathroom)
from houses_staging2
order by Bathroom asc;

update houses_staging2
set Bathroom = null
where Bathroom like '';
alter table houses_staging2 modify column Bathroom int;

select distinct(Bedroom2)
from houses_staging2
order by Bedroom2 asc;

update houses_staging2
set Bedroom2 = null
where Bedroom2 like '';
alter table houses_staging2 modify column Bedroom2 int;

select distinct(Car)
from houses_staging2
order by Car asc;

update houses_staging2
set Car = null
where Car like '';
alter table houses_staging2 modify column Car int;

select* from houses_staging2;

#Elimino una columna que no necesito 
ALTER TABLE houses_staging2
DROP COLUMN row_num;

#Ya tengo la columna Distance , entonces puedo eliminar Lattitude y Longtitude
ALTER TABLE houses_staging2
DROP COLUMN Lattitude ,
DROP COLUMN Longtitude;

#Analisis final 
select count(*) as filas_finales
from houses_staging2;

describe houses_staging2;
#Mirar datos que no tienen sentido y por lo tanto no deberian estar en el proyecto 
select count(*) as precios_invalidos
from houses_staging2
where Price <= 0;

select count(*) as rooms_en_cero
from houses_staging2
where Rooms = 0;

select Suburb, Landsize
from houses_staging2
where Landsize <0;

select distinct YearBuilt
from houses_staging2
where YearBuilt < 1800 or YearBuilt > 2030
order by YearBuilt;

select * 
from houses_staging2 #solo hay un dato, lo mejor sera remplazar este 1196 con null ya que es un dato atipico y poco razonable 
where YearBuilt = '1196' 
order by YearBuilt;
update houses_staging2
set YearBuilt = null
where YearBuilt = '1196' ;

select *
from houses_staging2
where YearBuilt = '' 
order by YearBuilt;

update houses_staging2
set YearBuilt = null
where YearBuilt like '';






