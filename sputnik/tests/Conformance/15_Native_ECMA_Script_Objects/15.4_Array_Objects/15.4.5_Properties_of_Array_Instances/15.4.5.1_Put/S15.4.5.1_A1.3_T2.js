// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.5.1_A1.3_T2;
 * @section: 15.4.5.1, 15.4;
 * @assertion: Set the value of property length of A to Uint32(length);
 * @description: Uint32 use ToNumber and ToPrimitve; 
*/

//CHECK#1
var x = [];
x.length = {valueOf: function() {return 2}};
if (x.length !== 2) {
  warn('#1: x = []; x.length = {valueOf: function() {return 2}};  x.length === 2. Actual: ' + (x.length));
}

//CHECK#2
x = [];
x.length = {valueOf: function() {return 2}, toString: function() {return 1}};
if (x.length !== 2) {
  warn('#0: x = []; x.length = {valueOf: function() {return 2}, toString: function() {return 1}};  x.length === 2. Actual: ' + (x.length));
} 

//CHECK#3
x = [];
x.length = {valueOf: function() {return 2}, toString: function() {return {}}};
if (x.length !== 2) {
  warn('#3: x = []; x.length = {valueOf: function() {return 2}, toString: function() {return {}}};  x.length === 2. Actual: ' + (x.length));
}

//CHECK#4
try {  
  x = [];
  x.length = {valueOf: function() {return 2}, toString: function() {throw "error"}};  
  if (x.length !== 2) {
    warn('#4.1: x = []; x.length = {valueOf: function() {return 2}, toString: function() {throw "error"}}; x.length === ",". Actual: ' + (x.length));
  }
}
catch (e) {
  if (e === "error") {
    warn('#4.2: x = []; x.length = {valueOf: function() {return 2}, toString: function() {throw "error"}}; x.length not throw "error"');
  } else {
    warn('#4.3: x = []; x.length = {valueOf: function() {return 2}, toString: function() {throw "error"}}; x.length not throw Error. Actual: ' + (e));
  }
}

//CHECK#5
x = [];
x.length = {toString: function() {return 1}};
if (x.length !== 1) {
  warn('#5: x = []; x.length = {toString: function() {return 1}};  x.length === 1. Actual: ' + (x.length));
}

//CHECK#6
x = [];
x.length = {valueOf: function() {return {}}, toString: function() {return 1}}
if (x.length !== 1) {
  warn('#6: x = []; x.length = {valueOf: function() {return {}}, toString: function() {return 1}};  x.length === 1. Actual: ' + (x.length));
}

//CHECK#7
try {
  x = [];
  x.length = {valueOf: function() {throw "error"}, toString: function() {return 1}};  
  x.length;
  warn('#7.1: x = []; x.length = {valueOf: function() {throw "error"}, toString: function() {return 1}}; x.length throw "error". Actual: ' + (x.length));
}  
catch (e) {
  if (e !== "error") {
    warn('#7.2: x = []; x.length = {valueOf: function() {throw "error"}, toString: function() {return 1}}; x.length throw "error". Actual: ' + (e));
  } 
}

//CHECK#8
try {
  x = [];
  x.length = {valueOf: function() {return {}}, toString: function() {return {}}};
  x.length;
  warn('#8.1: x = []; x.length = {valueOf: function() {return {}}, toString: function() {return {}}}  x.length throw TypeError. Actual: ' + (x.length));
}  
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#8.2: x = []; x.length = {valueOf: function() {return {}}, toString: function() {return {}}}  x.length throw TypeError. Actual: ' + (e));
  } 
}
