// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S9.8.1_A4;
 * @section: 9.8.1;
 * @assertion: If m is infinity, return the string "Infinity";
 * @description: +/-Infinity convert to String by explicit transformation;
*/

// CHECK#1
if (String(Infinity) !== "Infinity") {
  warn('#1: String(Infinity) === "Infinity". Actual: ' + (String(Infinity)));
}

// CHECK#2
if (String(Number.POSITIVE_INFINITY) !== "Infinity") {
  warn('#2: String(Number.POSITIVE_INFINITY) === "Infinity". Actual: ' + (String(Number.POSITIVE_INFINITY)));
}

// CHECK#3
if (String(-Infinity) !== "-Infinity") {
  warn('#3: String(-Infinity) === "-Infinity". Actual: ' + (String(-Infinity)));
}

// CHECK#4
if (String(Number.NEGATIVE_INFINITY) !== "-Infinity") {
  warn('#4: String(Number.NEGATIVE_INFINITY) === "-Infinity". Actual: ' + (String(Number.NEGATIVE_INFINITY)));
}
