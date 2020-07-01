// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.9.1_A7.9;
 * @section: 11.9.1, 11.9.3;
 * @assertion: If Type(x) is primitive type and Type(y) is Object, 
 * return x == ToPrimitive(y);
 * @description: y is object, x is primtitive;
 */

//CHECK#1
if ((true == {valueOf: function() {return 1}}) !== true) {
  warn('#1: (true == {valueOf: function() {return 1}}) === true');
}

//CHECK#2
if ((1 == {valueOf: function() {return 1}, toString: function() {return 0}}) !== true) {
  warn('#2: (1 == {valueOf: function() {return 1}, toString: function() {return 0}}) === true');
}

//CHECK#3
if (("+1" == {valueOf: function() {return 1}, toString: function() {return {}}}) !== true) {
  warn('#3: ("+1" == {valueOf: function() {return 1}, toString: function() {return {}}}) === true');
} 
  
//CHECK#4
try {
  if ((true == {valueOf: function() {return "+1"}, toString: function() {throw "error"}}) !== true) {
    warn('#4.1: (true == {valueOf: function() {return "+1"}, toString: function() {throw "error"}}) === true');
  }
}
catch (e) {
  if (e === "error") {
    warn('#4.2: (true == {valueOf: function() {return "+1"}, toString: function() {throw "error"}}) not throw "error"');
  } else {
    warn('#4.3: (true == {valueOf: function() {return "+1"}, toString: function() {throw "error"}}) not throw Error. Actual: ' + (e));
  }
}

//CHECK#5
if ((1 == {toString: function() {return "+1"}}) !== true) {
  warn('#5: (1 == {toString: function() {return "+1"}}) === true');
}

//CHECK#6
if (("1" == {valueOf: function() {return {}}, toString: function() {return "+1"}}) !== false) {
  warn('#6.1: ("1" == {valueOf: function() {return {}}, toString: function() {return "+1"}}) === false');
} else {
  if (("+1" == {valueOf: function() {return {}}, toString: function() {return "+1"}}) !== true) {
    warn('#6.2: ("+1" == {valueOf: function() {return {}}, toString: function() {return "+1"}}) === true');
  }
}

//CHECK#7
try {
  (1 == {valueOf: function() {throw "error"}, toString: function() {return 1}});
  warn('#7.1: (1 == {valueOf: function() {throw "error"}, toString: function() {return 1}}) throw "error". Actual: ' + ((1 == {valueOf: function() {throw "error"}, toString: function() {return 1}})));
}  
catch (e) {
  if (e !== "error") {
    warn('#7.2: (1 == {valueOf: function() {throw "error"}, toString: function() {return 1}}) throw "error". Actual: ' + (e));
  } 
}

//CHECK#8
try {
  (1 == {valueOf: function() {return {}}, toString: function() {return {}}});
  warn('#8.1: (1 == {valueOf: function() {return {}}, toString: function() {return {}}}) throw TypeError. Actual: ' + ((1 == {valueOf: function() {return {}}, toString: function() {return {}}})));
}  
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#8.2: (1 == {valueOf: function() {return {}}, toString: function() {return {}}}) throw TypeError. Actual: ' + (e));
  } 
}
