#!/bin/bash

# Create a database named "mydb"
evqlctl -c /etc/evqld.conf database-create --database "mydb"

# Connect to the database "mydb" using evql client
evql -d mydb

