// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.4.3_A3.5;
* @section: 11.4.3;
* @assertion: Result of appying "typeof" operator to string is "string";
* @description: typeof (string value) === "string";
*/

//CHECK#1
if (typeof "1" !== "string") {
  warn('#1: typeof "1" === "string". Actual: ' + (typeof "1"));
}

//CHECK#2
if (typeof "NaN" !== "string") {
  warn('#2: typeof "NaN" === "string". Actual: ' + (typeof "NaN"));
}

//CHECK#3
if (typeof "Infinity" !== "string") {
  warn('#3: typeof "Infinity" === "string". Actual: ' + (typeof "Infinity"));
}

//CHECK#4
if (typeof "" !== "string") {
  warn('#4: typeof "" === "string". Actual: ' + (typeof ""));
}

//CHECK#5
if (typeof "true" !== "string") {
  warn('#5: typeof "true" === "string". Actual: ' + (typeof "true"));
}

//CHECK#6
if (typeof Date() !== "string") {
  warn('#6: typeof Date() === "string". Actual: ' + (typeof Date()));
}
