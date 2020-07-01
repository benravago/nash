// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.7.3_A2.2_T1;
 * @section: 11.7.3, 8.6.2.6;
 * @assertion: Operator x >>> y uses [[Default Value]];
 * @description: If Type(value) is Object, evaluate ToPrimitive(value, Number);
 */

//CHECK#1
if ({valueOf: function() {return -4}} >>> 1 !== 2147483646) {
  warn('#1: {valueOf: function() {return -4}} >>> 1 === 2147483646. Actual: ' + ({valueOf: function() {return -4}} >>> 1));
}

//CHECK#2
if ({valueOf: function() {return -4}, toString: function() {return 0}} >>> 1 !== 2147483646) {
  warn('#2: {valueOf: function() {return -4}, toString: function() {return 0}} >>> 1 === 2147483646. Actual: ' + ({valueOf: function() {return -4}, toString: function() {return 0}} >>> 1));
}

//CHECK#3
if ({valueOf: function() {return -4}, toString: function() {return {}}} >>> 1 !== 2147483646) {
  warn('#3: {valueOf: function() {return -4}, toString: function() {return {}}} >>> 1 === 2147483646. Actual: ' + ({valueOf: function() {return -4}, toString: function() {return {}}} >>> 1));
}

//CHECK#4
try {
  if ({valueOf: function() {return -4}, toString: function() {throw "error"}} >>> 1 !== 2147483646) {
    warn('#4.1: {valueOf: function() {return -4}, toString: function() {throw "error"}} >>> 1 === 2147483646. Actual: ' + ({valueOf: function() {return -4}, toString: function() {throw "error"}} >>> 1));
  }
}
catch (e) {
  if (e === "error") {
    warn('#4.2: {valueOf: function() {return -4}, toString: function() {throw "error"}} >>> 1 not throw "error"');
  } else {
    warn('#4.3: {valueOf: function() {return -4}, toString: function() {throw "error"}} >>> 1 not throw Error. Actual: ' + (e));
  }
}

//CHECK#5
if (-4 >>> {toString: function() {return 1}} !== 2147483646) {
  warn('#5: -4 >>> {toString: function() {return 1}} === 2147483646. Actual: ' + (-4 >>> {toString: function() {return 1}}));
}

//CHECK#6
if (-4 >>> {valueOf: function() {return {}}, toString: function() {return 1}} !== 2147483646) {
  warn('#6: -4 >>> {valueOf: function() {return {}}, toString: function() {return 1}} === 2147483646. Actual: ' + (-4 >>> {valueOf: function() {return {}}, toString: function() {return 1}}));
}

//CHECK#7
try {
  -4 >>> {valueOf: function() {throw "error"}, toString: function() {return 1}};
  warn('#7.1: -4 >>> {valueOf: function() {throw "error"}, toString: function() {return 1}} throw "error". Actual: ' + (-4 >>> {valueOf: function() {throw "error"}, toString: function() {return 1}}));
}  
catch (e) {
  if (e !== "error") {
    warn('#7.2: -4 >>> {valueOf: function() {throw "error"}, toString: function() {return 1}} throw "error". Actual: ' + (e));
  } 
}

//CHECK#8
try {
  -4 >>> {valueOf: function() {return {}}, toString: function() {return {}}};
  warn('#8.1: -4 >>> {valueOf: function() {return {}}, toString: function() {return {}}} throw TypeError. Actual: ' + (e));
}  
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#8.2: -4 >>> {valueOf: function() {return {}}, toString: function() {return {}}} throw TypeError. Actual: ' + (e));
  } 
}
