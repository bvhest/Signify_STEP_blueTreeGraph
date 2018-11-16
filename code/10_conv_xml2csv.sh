#!/bin/bash
#
# create neo4j database with Signify Product tree and mandatory attributes from csv-data:

# product blue tree to category-nodes, including category links :
#java -cp /home/hestbv/Tools/Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/raw/prod_blue_tree.xml -xsl:10_prod_blue_tree_xml2csv.xsl -o:../data/raw/prod_blue_tree.csv

# attribute definitions to attribute-nodes, including links to product blue-tree and links that are mandatory:
java -cp /home/hestbv/Tools/Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/raw/attributes.xml -xsl:12_attributes_xml2csv.xsl -o:../data/raw/attributes.csv
