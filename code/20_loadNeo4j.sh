#!/bin/bash
#
# Signify STEP product database
#
# script om datamodel op te zetten en data te laden in de Neo4j database
#
# BvH, 2018-11-15
#

# Check if a directory does not exist:
if [ ! -d "/home/hestbv/Tools/neo4j-community-3.2.0/data/databases/graph.db/import" ] 
then
  mkdir /home/hestbv/Tools/neo4j-community-3.2.0/data/databases/graph.db/import
fi
# cp data-files to Neo4j import-directory:
cp /home/hestbv/Projecten/Neo4j/Signify/data/raw/prod_blue_tree.csv /home/hestbv/Tools/neo4j-community-3.2.0/data/databases/graph.db/import/prod_blue_tree_test.csv
cp /home/hestbv/Projecten/Neo4j/Signify/data/raw/attributes.csv /home/hestbv/Tools/neo4j-community-3.2.0/data/databases/graph.db/import/attributes_test.csv

# load data:
/home/hestbv/Tools/neo4j-community-3.2.0/bin/neo4j-shell -path /home/hestbv/Tools/neo4j-community-3.2.0/data/databases/graph.db -config /home/hestbv/Tools/neo4j-community-3.2.0/conf/neo4j.conf -file 20_neo4j-importCSV.cql
