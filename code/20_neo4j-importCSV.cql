//
// creation script for Neo4J-database
//
// STEP Product- & Attributes-data
//
// 1. data has been exported as plain STEP XML.
// 2. XML-files have been converted to CSV with '10_conv_xml2csv.sh'
//
// BvH, 2018-11-15
// BvH, 2019-03-21, added loading yellow tree. Order is yellow tree, blue tree, attributes.
//



//-----------------------------------------------------------------------------
// create constraints
//-----------------------------------------------------------------------------

// each node in the yellow tree must be unique:
CREATE CONSTRAINT ON (yt:YellowTree) ASSERT yt.id IS UNIQUE;

// each node in the blue tree must be unique:
CREATE CONSTRAINT ON (bt:BlueTree) ASSERT bt.id IS UNIQUE;

// each attribute must be unique:
CREATE CONSTRAINT ON (a:Attribute) ASSERT a.id IS UNIQUE;



//-----------------------------------------------------------------------------
// create nodes
//-----------------------------------------------------------------------------

// Navigation yellow-tree can be created with CREATE (all nodes and relations are new).
// Using CREATE will be more performand.

USING PERIODIC COMMIT 5000
LOAD csv WITH HEADERS FROM "file:///nav_yellow_tree_test.csv"
AS nodes
CREATE (yt:YellowTree {id: nodes.id, name: nodes.name, type: nodes.type});

// Product blue-tree can be created with CREATE (all nodes and relations are new).
// Using CREATE will be more performand.


//
// issues:
// 1) how to deal with double quotes within the text-strings in a csv-file ?
// https://neo4j.com/developer/kb/how-do-i-use-load-csv-with-data-including-quotes/

USING PERIODIC COMMIT 5000
LOAD csv WITH HEADERS FROM "file:///prod_blue_tree_test.csv"
AS nodes
CREATE (bt:BlueTree {id: nodes.id, name: nodes.name, type: nodes.type});


USING PERIODIC COMMIT 5000
LOAD csv WITH HEADERS FROM "file:///attributes_test.csv"
AS nodes
CREATE (attribute:Attribute {id: nodes.id, name: nodes.name});



//-----------------------------------------------------------------------------
// create indexes
//-----------------------------------------------------------------------------

CREATE INDEX ON :YellowTree(name);
//CREATE INDEX ON :YellowTree(id); // already created by definition of unique constraint

//schema await

// create indexes
CREATE INDEX ON :BlueTree(name);
//CREATE INDEX ON :BlueTree(id); // already created by definition of unique constraint

//schema await

// create indexes
//CREATE INDEX ON :Attribute(id);

schema await



//-----------------------------------------------------------------------------
// load relations/edges:
//-----------------------------------------------------------------------------

// yellow-tree relations
USING PERIODIC COMMIT 5000
LOAD csv WITH HEADERS FROM "file:///nav_yellow_tree_test.csv"
AS rels
MATCH (yellowtreeChild:YellowTree {id: rels.id}),(yellowtreeParent:YellowTree {id: rels.parent_id})
CREATE (yellowtreeChild)-[rel:IS_CATEGORISED_BY]->(yellowtreeParent);


// blue-tree relations
USING PERIODIC COMMIT 5000
LOAD csv WITH HEADERS FROM "file:///prod_blue_tree_test.csv"
AS rels
MATCH (bluetreeChild:BlueTree {id: rels.id}),(bluetreeParent:BlueTree {id: rels.parent_id_blue_tree})
CREATE (bluetreeChild)-[rel:IS_CHILD_OF]->(bluetreeParent);

// blue-tree-to-yellow-tree relations
USING PERIODIC COMMIT 5000
LOAD csv WITH HEADERS FROM "file:///prod_blue_tree_test.csv"
AS rels
MATCH (bluetreeChild:BlueTree {id: rels.id}),(yellowtreeParent:YellowTree {id: rels.parent_id_yellow_tree})
CREATE (bluetreeChild)-[rel:IS_CATEGORISED_BY]->(yellowtreeParent);


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
WITH row, split(row.valid_for, ";") AS rels
UNWIND rels AS rel
MATCH (at:Attribute {id: row.id}) 
MATCH (bt:BlueTree {id: rel}) 
MERGE (at)-[r:IS_VALID_FOR]->(bt)
ON CREATE SET r.mandatory = false
ON MATCH SET r.mandatory = false;
// 449 relations...

// not required as we have defined the mandatory attribute on the VALID_FOR-relation...
//
//USING PERIODIC COMMIT 5000
//LOAD csv WITH HEADERS FROM "file:///attributes_test.csv"
//AS row
//WITH row, split(row.mandatory_for, ";") AS rels
//UNWIND rels AS rel
//MATCH (at:Attribute {id: row.id}) 
//MATCH (bt:BlueTree {id: rel}) 
//MERGE (at)-[:IS_MANDATORY_FOR]->(bt);
// 8026 relations...


//ad 2: check:
//  - https://stackoverflow.com/questions/47567524/how-to-conditionally-add-property-to-relationship-from-csv-in-neo4j

USING PERIODIC COMMIT 5000
LOAD csv WITH HEADERS FROM "file:///attributes_test.csv"
AS row
WITH row, split(row.mandatory_for, ";") AS rels
UNWIND rels AS rel
MATCH (at:Attribute {id: row.id}) 
MATCH (bt:BlueTree {id: rel}) 
MERGE (at)-[r:IS_VALID_FOR]->(bt)
ON CREATE SET r.mandatory = true
ON MATCH SET r.mandatory = true;
