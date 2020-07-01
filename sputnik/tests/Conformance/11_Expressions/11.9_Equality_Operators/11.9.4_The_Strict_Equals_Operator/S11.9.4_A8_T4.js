// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.9.4_A8_T4;
 * @section: 11.9.4, 11.9.6;
 * @assertion: If Type(x) is different from Type(y), return false;  
 * @description: x or y is null or undefined; 
*/

//CHECK#1
if (undefined === null) {
  warn('#1: undefined !== null');
}

//CHECK#2
if (null === undefined) {
  warn('#2: null !== undefined');
}

//CHECK#3
if (null === 0) {
  warn('#3: null !== 0');
}

//CHECK#4
if (0 === null) {
  warn('#4: 0 !== null');
}

//CHECK#5
if (null === false) {
  warn('#5: null !== false');
}

//CHECK#6
if (false === null) {
  warn('#6: false !== null');
}

//CHECK#7
if (undefined === false) {
  warn('#7: undefined !== false');
}

//CHECK#8
if (false === undefined) {
  warn('#8: false !== undefined');
}

//CHECK#9
if (null === new Object()) {
  warn('#9: null !== new Object()');
}

//CHECK#10
if (new Object() === null) {
  warn('#10: new Object() !== null');
}

//CHECK#11
if (null === "null") {
  warn('#11: null !== "null"');
}

//CHECK#12
if ("null" === null) {
  warn('#12: "null" !== null');
}

//CHECK#13
if (undefined === "undefined") {
  warn('#13: undefined !== "undefined"');
}

//CHECK#14
if ("undefined" === undefined) {
  warn('#14: "undefined" !== undefined');
}
