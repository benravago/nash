// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.9.4_A5;
 * @section: 11.9.4, 11.9.6;
 * @assertion: Type(x) and Type(y) are String-s. 
 * Return true, if x and y are exactly the same sequence of characters; otherwise, return false;
 * @description: x and y are primitive strings;
 */

//CHECK#1
if (!("" === "")) {
  warn('#1: "" === ""');
}

//CHECK#2
if (!(" " === " ")) {
  warn('#2: " " === " "');
}

//CHECK#3
if (!("string" === "string")) {
  warn('#3: "string" === "string"');
}

//CHECK#4
if (" string" === "string ") {
  warn('#4: " string" !== "string "');
}

//CHECK#5
if ("1.0" === "1") {
  warn('#5: "1.0" !== "1"');
}
