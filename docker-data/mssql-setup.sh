#!/usr/bin/env bash

DB_GROUP=$1
DB_HOST=$2
DB_PORT=$3
DB_LOGIN_USER=$4
DB_LOGIN_PASSWORD=$5

ROOT_DIRECTORY="/app/docker-data"


insertData () {
    dataDir="$ROOT_DIRECTORY/${DB_GROUP}"
    for insertFile in "${dataDir}/"*.sql; do
        echo "Inserting/Updating data from file: ${insertFile}"
        sqlcmd -l 90 -S ${DB_HOST},${DB_PORT} -U ${DB_LOGIN_USER} -P ${DB_LOGIN_PASSWORD} -d master -i "${insertFile}"
        echo "Finish Insert/Update data from file: ${insertFile}"
    done
}

disableConstraints () {
    echo "Disabling ${DB_GROUP} constraints..."
    sqlcmd -l 90 -S ${DB_HOST},${DB_PORT} -U ${DB_LOGIN_USER} -P ${DB_LOGIN_PASSWORD} -d ${1} -i "$ROOT_DIRECTORY/disable_constraints.sql"
}

enableCrossDBPermission () {
    echo "Enabling cross-db SELECT permission on ${DB_GROUP}..."
    sqlcmd -l 90 -S ${DB_HOST},${DB_PORT} -U ${DB_LOGIN_USER} -P ${DB_LOGIN_PASSWORD} -d ${1} -i "$ROOT_DIRECTORY/enable_crossdb_permission.sql"
}

if [[ ${DB_GROUP} = 'spanky' ]]
then
    disableConstraints "spanky"
    wait

    enableCrossDBPermission "spanky"
    wait

    insertData
    wait

echo "### ${DB_GROUP} INITIALIZED! ###"
