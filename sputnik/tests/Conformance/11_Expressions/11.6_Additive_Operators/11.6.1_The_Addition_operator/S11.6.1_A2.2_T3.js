// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.6.1_A2.2_T3;
 * @section: 11.6.1, 8.6.2.6;
 * @assertion: Operator x + y uses [[Default Value]];
 * @description: If Type(value) is Function, evaluate ToPrimitive(value, Number); 
 */

//CHECK#1
function f1(){
  return 0;
}
if (f1 + 1 !== f1.toString() + 1) {
  warn('#1: function f1() {return 0;}; f1 + 1 === f1.toString() + 1');
}

//CHECK#2
function f2(){
  return 0;
}
f2.valueOf = function() {return 1;};
if (1 + f2 !== 1 + 1) {
  warn('#2: f1unction f2() {return 0;} f2.valueOf = function() {return 1;}; 1 + f2 === 1 + 1. Actual: ' + (1 + f2));
}

//CHECK#3
function f3(){
  return 0;
}
f3.toString = function() {return 1;};
if (1 + f3 !== 1 + 1) {
  warn('#3: f1unction f3() {return 0;} f3.toString() = function() {return 1;}; 1 + f3 === 1 + 1. Actual: ' + (1 + f3));
}

//CHECK#4
function f4(){
  return 0;
}
f4.valueOf = function() {return -1;};
f4.toString = function() {return 1;};
if (f4 + 1 !== 1 - 1) {
  warn('#4: f1unction f4() {return 0;}; f2.valueOf = function() {return -1;}; f4.toString() = function() {return 1;}; f4 + 1 === 1 - 1. Actual: ' + (f4 + 1));
}
