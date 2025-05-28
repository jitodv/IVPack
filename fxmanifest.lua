fx_version 'cerulean'
game 'gta5'

author 'jito_xd'
description 'IV Pack - Vehículos de GTA IV para FiveM // Original mod by _CP_ ' 
version '1.0.0'

-- Archivos de datos
files {
    'data/handling.meta',
    'data/vehicles.meta',
    'data/carcols.meta',
    'data/carvariations.meta',
    'data/dlctext.meta'
}

-- Asociaciones de archivos .meta
data_file 'HANDLING_FILE'          'data/handling.meta'
data_file 'VEHICLE_METADATA_FILE'  'data/vehicles.meta'
data_file 'CARCOLS_FILE'           'data/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/carvariations.meta'
data_file 'DLCTEXT_FILE'           'data/dlctext.meta'

-- Client script opcional (para spawnear o pruebas)
 client_script 'client.lua'
