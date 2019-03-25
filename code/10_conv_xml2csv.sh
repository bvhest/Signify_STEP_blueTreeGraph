##!/bin/bash
#
# Signify STEP product database
#
# script om datamodel op te zetten en data te laden in de Neo4j database
# create neo4j database with Signify Product tree and mandatory attributes from csv-data:
#
# BvH, 
# 2018-11-15 - first setup.
# 2019-03-20 - added navigation tree.
# 2019-03-21 - added relation between blue- and navigation tree.
#

# navigation yellow tree to navigation category-nodes:
java -cp /home/hestbv/Tools/Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/raw/nav_yellow_tree.xml -xsl:14_nav_yellow_tree_xml2csv.xsl -o:../data/csv/nav_yellow_tree.csv

# product blue tree to product category-nodes, including category links :
java -cp /home/hestbv/Tools/Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/raw/prod_blue_tree.xml -xsl:10_prod_blue_tree_xml2csv.xsl -o:../data/csv/prod_blue_tree.csv

# attribute definitions to attribute-nodes, including links to product blue-tree and links that are mandatory:
java -cp /home/hestbv/Tools/Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/raw/attributes.xml -xsl:12_attributes_xml2csv.xsl -o:../data/csv/attributes.csv

# product assets:
java -cp /home/hestbv/Tools/Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/raw/prod_blue_tree.xml -xsl:16_prod_assets_xml2csv.xsl -o:../data/csv/prod_assets.csv
