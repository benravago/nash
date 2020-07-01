// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.8.7_A3;
* @section: 11.8.7;
* @assertion: If ShiftExpression is not an object, throw TypeError;
* @description: Checking all the types of primitives;
*/

//CHECK#1
try {
  "toString" in true;
  warn('#1: "toString" in true throw TypeError');  
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#1: "toString" in true throw TypeError');  
  }
}

//CHECK#2
try {
  "MAX_VALUE" in 1;
  warn('#2: "MAX_VALUE" in 1 throw TypeError');  
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#2: "MAX_VALUE" in 1 throw TypeError');  
  }
}

//CHECK#3
try {
  "length" in "string";
  warn('#3: "length" in "string" throw TypeError');  
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#3: "length" in "string" throw TypeError');  
  }
}

//CHECK#4
try {
  "toString" in undefined;
  warn('#4: "toString" in undefined throw TypeError');  
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#4: "toString" in undefined throw TypeError');  
  }
}

//CHECK#5
try {
  "toString" in null;
  warn('#5: "toString" in null throw TypeError');  
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#5: "toString" in null throw TypeError');  
  }
}
