// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.4.5_A1.1_T1;
 * @section: 15.4.4.5;
 * @assertion: If length is zero, return the empty string;
 * @description: Checking this use new Array() and [];
*/

//CHECK#1
var x = new Array();
if (x.join() !== "") {
  warn('#1: x = new Array(); x.join() === "". Actual: ' + (x.join()));
}  

//CHECK#2
x = [];
x[0] = 1;
x.length = 0;
if (x.join() !== "") {
  warn('#2: x = []; x[0] = 1; x.length = 0; x.join() === "". Actual: ' + (x.join()));
}  
