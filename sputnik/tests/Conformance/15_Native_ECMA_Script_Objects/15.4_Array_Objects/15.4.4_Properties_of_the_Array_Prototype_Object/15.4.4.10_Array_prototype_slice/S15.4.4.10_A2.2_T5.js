// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.4.10_A2.2_T5;
 * @section: 15.4.4.10;
 * @assertion: Operator use ToInteger from end;
 * @description: ToInteger use ToNumber;
*/

var x = [0,1,2,3,4];
var arr = x.slice(0,{valueOf: function() {return 3}, toString: function() {return 0}});

//CHECK#1
arr.getClass = Object.prototype.toString;
if (arr.getClass() !== "[object " + "Array" + "]") {
  warn('#1: var x = [0,1,2,3,4]; var arr = x.slice(0,{valueOf: function() {return 3}, toString: function() {return 0}}); arr is Array object. Actual: ' + (arr.getClass()));
}

//CHECK#2
if (arr.length !== 3) {
  warn('#2: var x = [0,1,2,3,4]; var arr = x.slice(0,{valueOf: function() {return 3}, toString: function() {return 0}}); arr.length === 3. Actual: ' + (arr.length));
}      

//CHECK#3
if (arr[0] !== 0) {
  warn('#3: var x = [0,1,2,3,4]; var arr = x.slice(0,{valueOf: function() {return 3}, toString: function() {return 0}}); arr[0] === 0. Actual: ' + (arr[0]));
}

//CHECK#4
if (arr[1] !== 1) {
  warn('#4: var x = [0,1,2,3,4]; var arr = x.slice(0,{valueOf: function() {return 3}, toString: function() {return 0}}); arr[1] === 1. Actual: ' + (arr[1]));
}      

//CHECK#5
if (arr[2] !== 2) {
  warn('#5: var x = [0,1,2,3,4]; var arr = x.slice(0,{valueOf: function() {return 3}, toString: function() {return 0}}); arr[2] === 2. Actual: ' + (arr[2]));
}   

//CHECK#6
if (arr[3] !== undefined) {
  warn('#6: var x = [0,1,2,3,4]; var arr = x.slice(0,{valueOf: function() {return 3}, toString: function() {return 0}}); arr[3] === undefined. Actual: ' + (arr[3]));
}   
