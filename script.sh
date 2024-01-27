#!/usr/bin/bash

# Este guión crea una placa de noticia con imagen, título sobre gradiente y 
# logo usando las herramientas de línea de comandos de ImageMagick.
# Ajuste automático del tamaño del titular y redimensionamiento y recorte
# de la imagen de fondo para una proporción 1:1.

# Simple script for create news social media posts with dynamically sized 
# headline using the ImageMagick 's tools.

# Silvano Emanuel Roqués © 2023

SIZE=400
LOGO="sample.logo.png"

if [ $# != 2 ]; then echo "Uso: $0 fotografía \"título\""; exit 1; fi
if ! [[ -f $1 ]]; then echo "ERROR: $1 no existe"; exit 1; fi
if ! [[ `identify $1` ]]; then echo "ERROR: $1 no es una imagen"; exit 1; fi

# Preserva original
cp $1 copia-$1; base="copia-$1";

# Detectar orientación para redimensionar por coordenada de menor valor. 
read -r w h <<< `identify -format "%w %h" $base`
if([ $w > $h ]); then geom="x${SIZE}"; else geom="${SIZE}"; fi

mogrify -gravity Center -resize $geom -extent ${SIZE}x${SIZE}+0+0 $base 
mogrify -gravity Center -crop ${SIZE}x${SIZE}+0+0 $base 

# Crear gradiente
convert -size ${SIZE}x${SIZE} gradient:none-#0a476d png:~tmp0

# Componer
composite ~tmp0 $base ~tmp1
composite $LOGO -gravity SouthEast -geometry +15+20 ~tmp1 ~tmp2

read -r width height <<< `identify -format "%w %h" ~tmp2`
width_caja=`bc <<< "$width * 0.7 / 1"`; 
offset_caja_x=`bc <<< "($width - $width_caja) / 3 / 1"`;
height_caja=`bc <<< "$height * 0.30 / 1"`;
offset_caja_y=`bc <<< "$height * 0.60 / 1"`; 

echo "width: $width"
echo "width_caja: $width_caja"
echo "offset_caja_x: $offset_caja_x"
echo "height: $height"
echo "height_caja: $height_caja"
echo "offset_caja_y: $offset_caja_y"

#Otras fuentes: Frank-Ruehl-CLM-Bold, FreeSerif-Bold-Italic, Luxi-Sans-Bold, P052-Bold, David-CLM-Medium, DejaVu-Sans-Bold-Oblique, Kerkis-Bold
#Para t2: NimbusMono, 

convert ~tmp2 \( -size ${width_caja}x${height_caja}! -background none -fill white -font DejaVu-Sans-Bold-Oblique caption:"$2" -trim -gravity center -extent ${width_caja}x${height_caja} \) -gravity northwest -geometry +$offset_caja_x+$offset_caja_y  -composite salida.png
rm ~tmp0 ~tmp1 ~tmp2;
