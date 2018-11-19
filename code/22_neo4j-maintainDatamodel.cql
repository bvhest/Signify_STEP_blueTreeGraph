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

