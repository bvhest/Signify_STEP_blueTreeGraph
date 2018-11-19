//
// Usefull cypher queries for STEP database
//
// BHE, 15-11-2018
//

// remove relations for a specific type:
MATCH ()-[r:MANDATORY_FOR]-() DELETE r;

// select root-node from the product (blue) tree:
MATCH (bt:BlueTree{name:"Product Maintenance"})
RETURN bt;

// this node should have as mandatory attributes:
//  - RTLMPPWRGR
//  - HOUSINGGR
//  - RTLMPQTYGR
//  - LINEVOLT
//  - LINEFREQ
// and optional
//  - RATEDPOWER_NOM
//  - ETIMGRP
//  - LENA1
//  -STEP.*
MATCH (bt:BlueTree{name:"Lamp Drivers"})
RETURN bt;
// only the related bluetree objects show up...

MATCH (at:Attribute{id:"LINEVOLT"})
RETURN at;
// does not exist: not all attributes have been loaded...

MATCH path=(p:BlueTree{name:"Product Maintenance"})-[:BELONGS_TO*0..5]->(BlueTree{type:"Final Product") // match 0 to 5 CONTENTS hops
RETURN path, length(path) as len
ORDER BY len desc;

MATCH (p:BlueTree{name:"Product Maintenance"})-[:BELONGS_TO*]->(fp:BlueTree{type:"Final Product"}) 
RETURN fp;

// top-down:
// https://stackoverflow.com/questions/28120002/returning-an-entire-hierarchy-tree-using-neo4j-cypher
MATCH (category:Category { id: "whatever user picked" })-[:narrower]->(children:Category)
RETURN children
ORDER BY children.name;

// better: bottom-up
// get all final products, create a relation from the fp to the attribute that is a copy of the first category-to-attribute relation that is found.
MATCH (fp:BlueTree{type:"Final Product"})-[:BELONGS_TO*]->(parent:BlueTree)<-[rel:VALID_FOR]-(at:Attribute)
MERGE (at)-[r:VALID_FOR]->(fp)
ON CREATE SET r.mandatory = rel.mandatory;
