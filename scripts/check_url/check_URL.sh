#!/bin/bash
###############################
#
# Parametros:
#  - Lista Dominios y URL
#
#  Tareas:
#  - Se debera generar la estructura de directorio pedida con 1 solo comando con las tecnicas enseñadas en clases
#  - Generar los archivos de logs requeridos.
#
###############################
LISTA=$1

LOG_FILE="/var/log/status_URL.log"

DIRECTORIO="/tmp/head-check/"

ANT_IFS=$IFS
IFS=$'\n'

 if [[ ! -f $LOG_FILE ]]; then
	sudo touch $LOG_FILE
	echo "Se creo el archivo status_URL.log"
 fi

 if [[ ! -d $DIRECTORIO ]]; then
	 mkdir -p /tmp/head-check/{Error/{cliente,servidor},ok}
	 echo "Se creo el directorio $DIRECTORIO"
 fi


#---- Dentro del bucle ----#
  # Obtener el código de estado HTTP

 for LINEA in `cat $LISTA |  grep -v ^#`
 do
 	URL=$(echo $LINEA | awk '{print $2}')
	DOMINIO=$(echo $LINEA | awk '{print $1}')
	STATUS_CODE=$(curl -LI -o /dev/null -w '%{http_code}\n' -s "$URL")
	TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
	#echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" >> $LOG_FILE
	echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" | sudo tee -a $LOG_FILE
	
	if [[ $STATUS_CODE == 200 ]]; then
		touch "$DIRECTORIO/ok/$DOMINIO.com"
		echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" >> "$DIRECTORIO/ok/$DOMINIO.com"
	fi

	if [[ $STATUS_CODE -ge 400 && $STATUS_CODE -le 499 ]]; then
		touch "$DIRECTORIO/Error/cliente/$DOMINIO.com"
		echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" >> "$DIRECTORIO/Error/cliente/$DOMINIO.com"
	fi

	if [[ $STATUS_CODE -ge 500 && $STATUS_CODE -le 599 ]]; then
                touch "$DIRECTORIO/Error/servidor/$DOMINIO.com"
		echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" >> "$DIRECTORIO/Error/servidor/$DOMINIO.com"
        fi
	
 done
  
#-------------------------#

IFS=$ANT_IFS
