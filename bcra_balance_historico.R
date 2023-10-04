# Librerías ---------------------------------------------------------------------
library(readxl)
library(tidyverse)
library(lubridate)
library(dplyr)
library(tidyr)
library(writexl)


# Datos a modificar ------------------------------------------------------------
# En esta sección figura el último año en el que se extraen datos
# Afecta a la creación del vector hojas. Luego se borra.
ult <- 2022

# Preparación previa -----------------------------------------------------------
# Indica el link que lleva a la base de datos a utilizar
link <- "http://www.bcra.gov.ar/Pdfs/PublicacionesEstadisticas/Serieanual.xls"
# Indica donde descargar el archivo
download.file(link, destfile = "SerieBCRA.xls", mode = "wb")
# Crea un objeto con los nombres de cada hoja del archivo que se descarga, para luego leerlas
hojas <- c(paste0("Serie semanal ", 1998:2005), paste0("serie semanal ", 2006:ult))
# Objeto al que se le asignara la información
datos <- NULL
# Limpieza
rm(ult)


# Loop de extracción -----------------------------------------------------------
# Loop para que lea hoja por hoja el archivo Excel y lo guarde en un data frame ordenado
# En 2022, hubo un cambio de metodología contable. La fecha 31/12/22 tiene dos entradas:
#   - La que histórica
#   - La que continua desde el 31/12 en adelante
# Como solución, se quita el ajuste y la brecha se comienza a ver en 2023

for (j in hojas) {
  
  if (j == "serie semanal 2022") {
    serie <- read_excel("SerieBCRA.xls", sheet = j, skip = 3) %>%  # skip=3 indica que ignore las primeras 3 filas
      select(-ncol(.)) %>%
      rename(Grupo = 1) %>%                              # Renombra la 1er columna como Grupo
      gather(key = "dia", value = "Monto", -Grupo) %>%   # Transpone datos (formato largo)
      filter(!is.na(Monto)) %>%                          # Borra filas sin datos
      mutate(Monto = as.numeric(Monto)) %>%
      mutate(Grupo = trimws(gsub("[^[:alnum:] ]", "", Grupo)),        # Unifica nombres
             Grupo = gsub("  ", " ", toupper(Grupo)),                 # Todo mayúscula
             Grupo = chartr("?????", "AEIOU", Grupo),                 # Borra tildes
             fecha = as.Date(as.numeric(dia), origin = "1899-12-30")) # Convierte fecha a formato R
  } else {
    serie <- read_excel("SerieBCRA.xls", sheet = j, skip = 3) %>%  # skip=3 indica que ignore las primeras 3 filas
      rename(Grupo = 1) %>%                              # Renombra la 1er columna como Grupo
      gather(key = "dia", value = "Monto", -Grupo) %>%   # Transpone datos (formato largo)
      filter(!is.na(Monto)) %>%                          # Borra filas sin datos
      mutate(Monto = as.numeric(Monto)) %>%
      mutate(Grupo = trimws(gsub("[^[:alnum:] ]", "", Grupo)),        # Unifica nombres
             Grupo = gsub("  ", " ", toupper(Grupo)),                 # Todo mayúscula
             Grupo = chartr("?????", "AEIOU", Grupo),                 # Borra tildes
             fecha = as.Date(as.numeric(dia), origin = "1899-12-30")) # Convierte fecha a formato R
  }
  
  ## Problema de los 31 de diciembre con asteriscos en la fecha, se elimina el *
  serie$fecha[is.na(serie$fecha)] <- dmy(gsub(" .*", "", serie$dia[is.na(serie$fecha)]))
  
  ## Se junta todo, uniendo filas y eliminando la columna Día
  datos <- bind_rows(datos, serie) %>% select(-dia)
  
}

## Se remueve la base del último año ingresado al loop
rm(serie, hojas)


# Orden y depuración --------------------------------------------------------------
datos <- datos %>%
  filter(!is.na(Grupo)) %>%
  select(fecha, Grupo, Monto) 


# Funciones --------------------------------------------------------------------
# La función realiza tres procesos recurrentes para cuando se trasladan datos, 
# desde el dataframe "datos" hacia el dataframe "semanal":
#   - Borra fechas duplicadas
#   - Borra la columna Grupos del dataframe "datos"
#   - Renombra la columna "Monto" por la variable que se está tratando
# Los parámetros de la función son:
#   - base = la base de datos que va a ser afectada por la función.
#   - col = el string de la columna renombrada por la función

bcra <- function(base, col) {
  base <- base[(!duplicated(base)),]
  base$Grupo <- NULL
  names(base)[names(base) == "Monto"] <- col
  return(base)
}


# Filtrado de las bases semanales-----------------------------------------------

## * tipo_cambio ####
TdC <- filter(datos, Grupo == "TIPO DE CAMBIO")

## * activo_bcra ####
# Total Activo
TA <- filter(datos, Grupo == "TOTAL DEL ACTIVO")

## * reservas_pesos ####
# Reservas internacionales en pesos ($)
RIP <-filter(datos, Grupo %in% c("RESERVAS INTERNACIONALES","RESERVAS DE LIBRE DISPONIBILIDAD",
                                 "ORO DIVISAS COLOCACIONES A PLAZO Y OTROS"))

## * divisas_pesos ####
DIV <- filter(datos, Grupo == "DIVISAS")

## * convenio_multilateral ####
CONV <- filter(datos, Grupo %in% c("CONVENIOS MULTILATERALES DE CREDITO", "CONVENIOS MULTILATERALES DE CRÉDITO"))

## * titulos_publicos ####
TPUBL <- filter(datos, Grupo %in% c("TITULOS PUBLICOS"))
### NOTA: TITULOS PUBLICOS en mayúsculas y sin acento toma el rubro más agregado del balance.
###       Si se toman con acento (Ej: Títulos) capta rubros desagregados.

## * adelantos_transitorios ####
AT <-filter(datos, Grupo == "ADELANTOS TRANSITORIOS AL GOBIERNO NACIONAL")

## * credito_sist_financiero ####
# Créditos al sistema financiero del país
C <-filter(datos, Grupo == "CREDITOS AL SISTEMA FINANCIERO DEL PAIS")

## * pasivo_bcra ####
# Total Pasivo
TP <- filter(datos, Grupo == "TOTAL DEL PASIVO")

## * base_monetaria ####
# Base monetaria en millones de pesos
BM <-filter(datos, Grupo == "BASE MONETARIA")

## * circulacion_monetaria ####
CIRC <-filter(datos, Grupo %in% c("CIRCULACION MONETARIA", "CIRCULACIÓN MONETARIA"))
CIRC$Monto <- as.numeric(CIRC$Monto)

## * oblig_organismos_internales ####
ORGINT <-filter(datos, Grupo == "OBLIGACIONES CON ORGANISMOS INTERNACIONALES")

## * titulos_emitidos_bcra ####
# Títulos emitidos por el BCRA 
TIT <-filter(datos, Grupo == "TITULOS EMITIDOS POR EL BCRA")

## * letras_intransferibles ####
# Letras intransferibles del tesoro nacional. Se genera el siguiente criterio:
#   - Se genera un filtro en el que se guardan todas las filas que contienen letras intransferibles.
#   - El valor de la variable es la suma de todas las filas que corresponden a letras intransferibles.
#   - Se excluyen los cálculos patrimoniales del BCRA con o sin letras.
LI <- datos %>% 
  filter(grepl("LETRA.*INTRANSFERIBLE", Grupo) & !grepl("PATRIMONIO NETO", Grupo)) %>% 
  group_by(fecha) %>% 
  summarise(Monto = sum(Monto)) %>% 
  mutate(Grupo = 0)


# Arreglo bases semanales ------------------------------------------------------

## Identificación de bases y variables ####
# A cada nombre de base (en bases), le corresponde un nombre de variable (en colum)
bases <- c("TdC",                                                               # Tipo de cambio 
           "TA", "RIP", "DIV", "CONV", "TPUBL", "AT", "C",                      # Activo BCRA
           "TP", "BM", "CIRC", "ORGINT", "TIT", "LI")

colum <- c("tipo_cambio",
           "activo_bcra",
           "reservas_pesos",
           "divisas_pesos",
           "convenio_multilateral",
           "titulos_publicos",
           "adelantos_transitorios",
           "credito_sist_financiero",
           "pasivo_bcra",
           "base_monetaria",
           "circulacion_monetaria",
           "oblig_organismos_internales",
           "titulos_emitidos_bcra",
           "letras_intransferibles")

tracker <- as.data.frame(cbind(bases,colum))

## Loop para variables ####
# Acá es donde aplica la función bcra
for (i in (1:nrow(tracker))) {
  base_name <- tracker$bases[i]
  col <- tracker$colum[i]
  
  base <- get(base_name) 
  base <- bcra(base, col)
  
  assign(base_name, base)
}

rm(base, tracker, base_name, col, i, j)


# Unión de bases semanales -----------------------------------------------------

## Base de inicio ####
# Se empieza con TdC, que tiene el tipo de cambio
# TdC es el primer dataframe del vector bases
# Se dejan ordenados cálculos de tiempo al inicio

semanal <- TdC %>% 
  mutate(dia = day(fecha),
         mes = month(fecha),
         anio = year(fecha)) %>% 
  select(fecha, dia, mes, anio, tipo_cambio)

## Loop de left-joins ####
for (nombre in bases[-1]) {
  base_to_join <- get(nombre)
  semanal <- left_join(semanal, base_to_join, by = "fecha")
}
rm(base_to_join)

## Limpieza ####
for (nombre in bases) {
  if (exists(nombre, envir = .GlobalEnv)) {
    rm(list = nombre, envir = .GlobalEnv)
  }
}
rm(nombre)

## Condiciona numérico ####
for (col_name in colum) {
  semanal[[col_name]] <- as.numeric(semanal[[col_name]])
}


# Re-escala a millones ---------------------------------------------------------
# La base original está en miles de $
# Re-escala desde activo_bcra [6] a letras_intransferibles [18] a millones de pesos.
semanal <- semanal %>%
  mutate_at(vars(names(semanal)[6:18]), ~ round(. / 1000, digits = 3)) %>% 
  mutate(tipo_cambio = round(tipo_cambio, digits = 3))


# Cálculo de variables adicionales ---------------------------------------------

## * reservas_dolares ####
# Reservas internacionales en dólares (u$s)
# Se calcula directamente como reservas en pesos/ tipo de cambio de la semana
semanal$reservas_dolares <- semanal$reservas_pesos/semanal$tipo_cambio

## * ratio_reservas_base ####
semanal$ratio_reservas_base <-semanal$reservas_pesos/semanal$base_monetaria


# Depurado y guardado ----------------------------------------------------------
## Depurado ####
semanal <- semanal[!is.na(semanal$fecha), ]

## Guardado ####
save(semanal, file = "historico22.RData")

