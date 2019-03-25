#!/bin/bash
#
# Signify STEP product database
#
# script om datamodel op te zetten en data te laden in de Neo4j database
#
# BvH, 2018-11-15
# BvH, 2019-03-21, added loading yellow tree. Order is yellow tree, blue tree, attributes.
#

# Check if a directory does not exist:
if [ ! -d "/home/hestbv/Tools/neo4j-community-3.2.0/data/databases/graph.db/import" ] 
then
  mkdir /home/hestbv/Tools/neo4j-community-3.2.0/data/databases/graph.db/import
fi
# cp data-files to Neo4j import-directory:
mv /home/hestbv/Projecten/Neo4j/Signify_STEPdatamodel/data/csv/nav_yellow_tree.csv /home/hestbv/Tools/neo4j-community-3.2.0/data/databases/graph.db/import/nav_yellow_tree.csv
mv /home/hestbv/Projecten/Neo4j/Signify_STEPdatamodel/data/csv/prod_blue_tree.csv /home/hestbv/Tools/neo4j-community-3.2.0/data/databases/graph.db/import/prod_blue_tree.csv
mv /home/hestbv/Projecten/Neo4j/Signify_STEPdatamodel/data/csv/attributes.csv /home/hestbv/Tools/neo4j-community-3.2.0/data/databases/graph.db/import/attributes.csv
mv /home/hestbv/Projecten/Neo4j/Signify_STEPdatamodel/data/csv/prod_assets.csv /home/hestbv/Tools/neo4j-community-3.2.0/data/databases/graph.db/import/prod_assets.csv

# load data:
/home/hestbv/Tools/neo4j-community-3.2.0/bin/neo4j-shell -path /home/hestbv/Tools/neo4j-community-3.2.0/data/databases/graph.db -config /home/hestbv/Tools/neo4j-community-3.2.0/conf/neo4j.conf -file 20_neo4j-importCSV.cql > databaseCreation.log
