#Instalar las siguiente librerias



library(dplyr)
library(rvest)
library(httr)
library(tidyverse)
library(RCurl)
library(lubridate)


url_scl <- "https://www.flightstats.com/go/weblet?guid=d56928966b03ae86:-3be13f33:1197c2fe4bc:38ea&weblet=status&action=AirportFlightStatus&airportCode=SCL"

# funcion extraccion

print("Extracting data...")
fun_body <- function(x) {
  
  body <- list(
    language =	"English",
    startAction	= "AirportFlightStatus",
    imageColor = "orange",
    airportQueryTimePeriod = x, # parametro que trae el periodo de tiempo consultado
    airportQueryType =	0
    
  )
  
  r <- POST(url_scl, body = body)
  stop_for_status(r)
  
  r_scl_2 <- read_html(r) %>% 
    html_nodes("table.tableListingTable") %>% 
    html_table() %>% 
    as.data.frame() 
  
  colnames(r_scl_2) = r_scl_2[1, ] # the first row will be the header
  r_scl_2 = r_scl_2[-1, ] # remove first row or delete duplicate firt row
  
  return(r_scl_2)
}

df <- purrr::map_df(1:8, fun_body)
fecha_act <- today()
df <- df %>% mutate(fecha_recolecc = paste0(day(fecha_act),"-",month(fecha_act),"-",year(fecha_act)))

print("Saving file...")
write.csv(df,paste0("//CHILEX100/Samuel_testing/",today(),"_datosAeropuertoSCL.csv"), row.names = FALSE)
paste0("Guardado con éxito el: ",now())





 
