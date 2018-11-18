//
// creation script for Neo4J-database
//
// STEP Product- & Attributes-data
//
// 1. data has been exported as plain STEP XML.
// 2. XML-files have been converted to CSV with '10_conv_xml2csv.sh'
// csv-files have been prepared with 'preprocessLBSNdata.R' R-script.
//
// BHE, 15-11-2018
//

// Product blue-tree can be created with CREATE (all nodes and relations are new).
// Using CREATE will be more performand.

// each node in the bluetree must be unique:
//CREATE CONSTRAINT ON (bt:BlueTree) ASSERT bt.id IS UNIQUE;

USING PERIODIC COMMIT 5000
LOAD csv WITH HEADERS FROM "file:///prod_blue_tree_test.csv"
AS nodes
CREATE (bt:BlueTree {id: nodes.id, name: nodes.name, type: nodes.type});

// create indexes
//CREATE INDEX ON :BlueTree(name);
//CREATE INDEX ON :BlueTree(id);

//schema await


// each attribute must be unique:
CREATE CONSTRAINT ON (a:Attribute) ASSERT a.id IS UNIQUE;

USING PERIODIC COMMIT 5000
LOAD csv WITH HEADERS FROM "file:///attributes_test.csv"
AS nodes
CREATE (attribute:Attribute {id: nodes.id, name: nodes.name});

// create indexes
CREATE INDEX ON :Attribute(id);

schema await



// load relations/edges:

// blue-tree relations
USING PERIODIC COMMIT 5000
LOAD csv WITH HEADERS FROM "file:///prod_blue_tree_test.csv"
AS rels
MATCH (bluetreeChild:BlueTree {id: rels.id}),(bluetreeParent:BlueTree {id: rels.parent_id})
CREATE (bluetreeChild)-[rel:BELONGS_TO]->(bluetreeParent);

// attribute to blue-tree relations
//
// issues:
// 1) how to deal with comma-separated list ?
// 2) how to define metadata on the relations ?

//ad 1: check:
//  - https://neo4j.com/docs/developer-manual/current/cypher/clauses/unwind/
//  - https://markhneedham.com/blog/2014/07/10/neo4j-load-csv-processing-hidden-arrays-in-your-csv-documents/

USING PERIODIC COMMIT 5000
LOAD csv WITH HEADERS FROM "file:///attributes_test.csv"
AS row
WITH row, split(row.reference, ";") AS rels
UNWIND rels AS rel
MATCH (at:Attribute {id: row.id}) 
MATCH (bt:BlueTree {id: rel}) 
MERGE (at)-[:VALID_FOR]->(bt);

//ad 2: check:
//  - https://stackoverflow.com/questions/47567524/how-to-conditionally-add-property-to-relationship-from-csv-in-neo4j

USING PERIODIC COMMIT 5000
LOAD csv WITH HEADERS FROM "file:///attributes_test.csv"
AS row
WITH row, split(row.mandatory, ";") AS rels
UNWIND rels AS rel
MATCH (at:Attribute {id: row.id}) 
MATCH (bt:BlueTree {id: rel}) 
MERGE (at)-[r:VALID_FOR]->(bt)
ON CREATE SET r.mandatory = true
ON MATCH SET r.mandatory = true;
