// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S8.4_A1;
 * @section: 8.4, 7.8.4;
 * @assertion: Any variable that has been assigned with string literal has the type string;
 * @description: Check type of variable that has been assigned with string literal;
*/

/////////////////////////////////////////////////////////
// CHECK#1
var str="abcdfg";
if (typeof(str)!=="string"){
  warn('#1: var str="abcdfg"; typeof(str) === "string". Actual: ' + (typeof(str)));
}
//
////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////
// CHECK#2
var str2='qwerty';
if (typeof(str2)!=="string"){
  warn('#2: var str2=\'qwerty\'; typeof(str) === "string". Actual: ' + (typeof(str2)));
}
//
////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////
// CHECK#3
var __str='\u0042\u0043\u0044\u0045\u0046\u0047\u0048';
if (typeof(__str)!=="string"){
  warn('#3: var __str=\'\\u0042\\u0043\\u0044\\u0045\\u0046\\u0047\\u0048\'; typeof(__str) === "string". Actual: ' + (typeof(__str)));
}
//
////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////
// CHECK#4
var str__="\u0042\u0043\u0044\u0045\u0046\u0047\u0048";
if (typeof(str__)!=="string"){
  warn('#4: var str__="abcdfg"; typeof(str__) === "string". Actual: ' + (typeof(str__)));
}
//
////////////////////////////////////////////////////////
