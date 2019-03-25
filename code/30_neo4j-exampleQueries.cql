//
// Usefull cypher queries for STEP Product database
//
// BHE, 2019-03-22
//

// select mandatory attributes for a specific category in the yellow tree:
MATCH (a:Attribute)-[:IS_VALID_FOR]->(bt:BlueTree)-[:IS_CATEGORISED_BY]->(yt:YellowTree)
WHERE yt.id = "PROF-LEDSPOT" //LED spots
RETURN a
LIMIT 5;

// langzaam opbouwen: werkt!
MATCH (bt:BlueTree)-[:IS_CATEGORISED_BY*]->(yt:YellowTree)
 WHERE yt.id = "PROF-LEDSPOT" //LED spots
 RETURN bt
 LIMIT 5;

MATCH (a:Attribute)-[:IS_VALID_FOR*]->(bt:BlueTree)-[:IS_CATEGORISED_BY*]->(yt:YellowTree)
WHERE yt.id = "PROF-LEDSPOT" //LED spots
RETURN a
LIMIT 5;
// probleem: attributen zijn geldig voor een hoger niveau in de blue-tree dan gematched wordt met bovenstaande query.



// hulp van stack overflow:
//   https://stackoverflow.com/questions/55317542/neo4j-cypher-how-to-query-inherited-reations-on-a-child-node
//
MATCH (p:BlueTree {Id:$productiId)-[:BELONGS_TO*]->(bt:BlueTree)<-[:VALID_FOR]-(spec:Attribute)
RETURN s

MATCH (p:BlueTree {id:"FP-929001944408"})-[:IS_CHILD_OF*]->(bt:BlueTree)<-[:IS_VALID_FOR]-(spec:Attribute)
RETURN spec;

// is it possible to join the two queries: YES !

MATCH (p:BlueTree)-[:IS_CATEGORISED_BY*]->(yt:YellowTree),
(p:BlueTree)-[:IS_CHILD_OF*]->(bt:BlueTree)<-[:IS_VALID_FOR]-(spec:Attribute)
WHERE yt.id = "PROF-LEDSPOT" //LED spots
RETURN spec
LIMIT 50;  // need to limit to prevent a browser-crash...

// next: deduplicate the results.
MATCH (p:BlueTree)-[:IS_CATEGORISED_BY*]->(yt:YellowTree),
(p:BlueTree)-[:IS_CHILD_OF*]->(bt:BlueTree)<-[:IS_VALID_FOR]-(spec:Attribute)
WHERE yt.id = "PROF-LEDSPOT" //LED spots
RETURN DISTINCT spec; // query-time is 3000 ms

// next: also retrieve the mandatory-attribute on the product-specification-relation.
MATCH (p:BlueTree)-[:IS_CATEGORISED_BY*]->(yt:YellowTree),
(p:BlueTree)-[:IS_CHILD_OF*]->(bt:BlueTree)<-[r:IS_VALID_FOR]-(spec:Attribute)
WHERE yt.id = "PROF-LEDSPOT" //LED spots
RETURN DISTINCT spec, r.mandatory;  // query-time increases from 3000 to 4000 ms

// DONE ! (2019-03-25)

MATCH (p:BlueTree)-[:IS_CATEGORISED_BY*]->(yt:YellowTree),
(p:BlueTree)-[:IS_CHILD_OF*]->(bt:BlueTree)<-[r:IS_VALID_FOR]-(spec:Attribute)
WHERE yt.id = "PROF-LEDSPOT" //LED spots
RETURN DISTINCT yt.name, bt.id, bt.name, spec.id, spec.name , r.mandatory
ORDER BY spec.id; // query-time increases from 4000 to 8500 ms

