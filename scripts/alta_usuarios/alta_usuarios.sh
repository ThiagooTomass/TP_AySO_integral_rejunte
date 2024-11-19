#!/bin/bash

###############################
#
# Parametros:
#  - Lista de Usuarios a crear
#  - Usuario del cual se obtendra la clave
#
#  Tareas:
#  - Crear los usuarios segun la lista recibida en los grupos descriptos
#  - Los usuarios deberan de tener la misma clave que la del usuario pasado por parametro
#
###############################

LISTA=$1
USER=$2

USUARIO_CLAVE=$(sudo grep $USER /etc/shadow | awk -F ':' '{print $2}')

ANT_IFS=$IFS
IFS=$'\n'

for LINEA in `cat $LISTA |  grep -v ^#`
do
	USUARIO=$(echo  $LINEA |awk -F ',' '{print $1}')
	GRUPO=$(echo  $LINEA |awk -F ',' '{print $2}')
	DIRECTORIO=$(echo $LINEA | awk -F ',' '{print $3}')
	
	if [[ "$(grep -c "$USUARIO" /etc/shadow)" -eq 0 ]];then

		if [[ "$(grep -c "$GRUPO:" /etc/group)" -eq 0 ]]; then
                	echo "El grupo $GRUPO se va a crear."
                	sudo groupadd $GRUPO
		else
			echo "El grupo ya existia: $GRUPO"
		fi
		
		echo "El usuario se va a crear..."
		sudo useradd -m -d $DIRECTORIO -s /bin/bash -g $GRUPO -p "$USUARIO_CLAVE" $USUARIO

	else
		echo "El usuario ya existe"

		fi	
	
done
IFS=$ANT_IFS
