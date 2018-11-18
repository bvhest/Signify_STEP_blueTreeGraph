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
CREATE CONSTRAINT ON (bt:BlueTree) ASSERT bt.id IS UNIQUE;


using periodic commit 5000
load csv with headers from "file:prod_blue_tree_test.csv"
as nodes
create (bluetree:BlueTree {id: nodes.id, name: nodes.name});

// create indexes
CREATE INDEX ON :BlueTree(name);
CREATE INDEX ON :BlueTree(id);

schema await


// each attribute must be unique:
CREATE CONSTRAINT ON (a:Attribute) ASSERT a.id IS UNIQUE;

using periodic commit 5000
load csv with headers from "file:attributes_test.csv"
as nodes
create (attribute:Attribute {id: nodes.id, name: nodes.name});

// create indexes
CREATE INDEX ON :Attribute(id);

schema await



// load relations/edges:

// blue-tree relations
USING PERIODIC COMMIT 5000
load csv with headers from "file:prod_blue_tree_test.csv"
as rels
match (bluetreeChild:BlueTree {id: rels.id}),(bluetreeParent:BlueTree {id: rels.parent_id})
create (bluetreeChild)-[rel:BELONGS_TO]->(bluetreeParent);

// attribute to blue-tree relations
USING PERIODIC COMMIT 5000
load csv with headers from "file:attributes_test.csv"
as rels
match (attribute:Attribute {id: rels.id}),(bluetree:BlueTree {id: rels.parent_id})
create (attribute)-[rel:VALID_FOR]->(bluetree);

// issues:
// 1) how to deal with comma-separated list ?
// 2) how to define metadata on the relations ?

ad 1: check:
  - https://neo4j.com/docs/developer-manual/current/cypher/clauses/unwind/
  - https://markhneedham.com/blog/2015/06/04/neo4j-cypher-step-by-step-to-creating-a-linked-list-of-adjacent-nodes-using-unwind/


MATCH (T2:Test2)
UNWIND split(T2.from, ",") as id
MATCH (T1:Test1) WHERE T1._id = id
MERGE (T1)-[:HAS]->(T2)