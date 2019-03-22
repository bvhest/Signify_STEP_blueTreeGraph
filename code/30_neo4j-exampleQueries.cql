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
