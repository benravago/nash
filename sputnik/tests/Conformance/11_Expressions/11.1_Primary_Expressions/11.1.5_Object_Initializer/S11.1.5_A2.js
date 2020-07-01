// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.1.5_A2;
* @section: 11.1.5;
* @assertion: Evaluate the production ObjectLiteral: { PropertyName : AssignmentExpression };
* @description: Creating property "prop" of various types(boolean, number and etc.);
*/

//CHECK#1
var x = true;
var object = {prop : x}; 
if (object.prop !== x) {
  warn('#1: var x = true; var object = {prop : x}; object.prop === x. Actual: ' + (object.prop));
}

//CHECK#2
var x = new Boolean(true);
var object = {prop : x}; 
if (object.prop !== x) {
  warn('#2: var x = new Boolean(true); var object = {prop : x}; object.prop === x. Actual: ' + (object.prop));
}

//CHECK#3
var x = 1;
var object = {prop : x}; 
if (object.prop !== x) {
  warn('#3: var x = 1; var object = {prop : x}; object.prop === x. Actual: ' + (object.prop));
}

//CHECK#4
var x = new Number(1);
var object = {prop : x}; 
if (object.prop !== x) {
  warn('#4: var x = new Number(1); var object = {prop : x}; object.prop === x. Actual: ' + (object.prop));
}

//CHECK#5
var x = "1";
var object = {prop : x}; 
if (object.prop !== x) {
  warn('#5: var x = "1"; var object = {prop : x}; object.prop === x. Actual: ' + (object.prop));
}

//CHECK#6
var x = new String(1);
var object = {prop : x}; 
if (object.prop !== x) {
  warn('#6: var x = new String(1); var object = {prop : x}; object.prop === x. Actual: ' + (object.prop));
}

//CHECK#7
var x = undefined;
var object = {prop : x}; 
if (object.prop !== x) {
  warn('#7: var x = undefined; var object = {prop : x}; object.prop === x. Actual: ' + (object.prop));
}

//CHECK#8
var x = null;
var object = {prop : x}; 
if (object.prop !== x) {
  warn('#8: var x = null; var object = {prop : x}; object.prop === x. Actual: ' + (object.prop));
}

//CHECK#9
var x = {};
var object = {prop : x}; 
if (object.prop !== x) {
  warn('#9: var x = {}; var object = {prop : x}; object.prop === x. Actual: ' + (object.prop));
}

//CHECK#10
var x = [1,2];
var object = {prop : x}; 
if (object.prop !== x) {
  warn('#10: var x = [1,2]; var object = {prop : x}; object.prop === x. Actual: ' + (object.prop));
}

//CHECK#11
var x = function() {};
var object = {prop : x}; 
if (object.prop !== x) {
  warn('#11: var x = function() {}; var object = {prop : x}; object.prop === x. Actual: ' + (object.prop));
}

//CHECK#12
var x = this;
var object = {prop : x}; 
if (object.prop !== x) {
  warn('#12: var x = this; var object = {prop : x}; object.prop === x. Actual: ' + (object.prop));
}
