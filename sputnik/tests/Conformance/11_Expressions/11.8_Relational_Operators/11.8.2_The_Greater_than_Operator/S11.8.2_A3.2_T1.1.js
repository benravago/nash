// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.8.2_A3.2_T1.1;
 * @section: 11.8.2;
 * @assertion: If Type(Primitive(x)) is String and Type(Primitive(y)) is String, then operator x > y returns ToString(x) > ToString(y); 
 * @description: Type(Primitive(x)) and Type(Primitive(y)) vary between primitive string and String object;
*/

//CHECK#1
if ("1" > "1" !== false) {
  warn('#1: "1" > "1" === false');
}

//CHECK#2
if (new String("1") > "1" !== false) {
  warn('#2: new String("1") > "1" === false');
}

//CHECK#3
if ("1" > new String("1") !== false) {
  warn('#3: "1" > new String("1") === false');
}

//CHECK#4
if (new String("1") > new String("1") !== false) {
  warn('#4: new String("1") > new String("1") === false');
}

//CHECK#5
if ("x" > "1" !== true) {
  warn('#5: "x" > "1" === true');
}

//CHECK#6
if ("1" > "x" !== false) {
  warn('#6: "1" > "x" === false');
}
