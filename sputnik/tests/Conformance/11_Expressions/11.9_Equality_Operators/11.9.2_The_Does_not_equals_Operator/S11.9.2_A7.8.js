// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.9.2_A7.8;
 * @section: 11.9.2, 11.9.3;
 * @assertion: If Type(x) is Object and Type(y) is primitive type, 
 * return ToPrimitive(x) != y;
 * @description: x is object, y is primtitive;
 */

//CHECK#1
if ((true != {valueOf: function() {return 1}}) !== false) {
  warn('#1: (true != {valueOf: function() {return 1}}) === false');
}

//CHECK#2
if ((1 != {valueOf: function() {return 1}, toString: function() {return 0}}) !== false) {
  warn('#2: (1 != {valueOf: function() {return 1}, toString: function() {return 0}}) === false');
}

//CHECK#3
if (("+1" != {valueOf: function() {return 1}, toString: function() {return {}}}) !== false) {
  warn('#3: ("+1" != {valueOf: function() {return 1}, toString: function() {return {}}}) === false');
} 
  
//CHECK#4
try {
  if ((true != {valueOf: function() {return "+1"}, toString: function() {throw "error"}}) !== false) {
    warn('#4.1: (true != {valueOf: function() {return "+1"}, toString: function() {throw "error"}}) === false');
  }
}
catch (e) {
  if (e === "error") {
    warn('#4.2: (true != {valueOf: function() {return "+1"}, toString: function() {throw "error"}}) not throw "error"');
  } else {
    warn('#4.3: (true != {valueOf: function() {return "+1"}, toString: function() {throw "error"}}) not throw Error. Actual: ' + (e));
  }
}

//CHECK#5
if ((1 != {toString: function() {return "+1"}}) !== false) {
  warn('#5: (1 != {toString: function() {return "+1"}}) === false');
}

//CHECK#6
if (("1" != {valueOf: function() {return {}}, toString: function() {return "+1"}}) !== true) {
  warn('#6.1: ("1" != {valueOf: function() {return {}}, toString: function() {return "+1"}}) === true');
} else {
  if (("+1" != {valueOf: function() {return {}}, toString: function() {return "+1"}}) !== false) {
    warn('#6.2: ("+1" != {valueOf: function() {return {}}, toString: function() {return "+1"}}) === false');
  }
}

//CHECK#7
try {
  (1 != {valueOf: function() {throw "error"}, toString: function() {return 1}});
  warn('#7: (1 != {valueOf: function() {throw "error"}, toString: function() {return 1}}) throw "error"');
}  
catch (e) {
  if (e !== "error") {
    warn('#7: (1 != {valueOf: function() {throw "error"}, toString: function() {return 1}}) throw "error"');
  } 
}

//CHECK#8
try {
  (1 != {valueOf: function() {return {}}, toString: function() {return {}}});
  warn('#8: (1 != {valueOf: function() {return {}}, toString: function() {return {}}}) throw TypeError');
}  
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#8: (1 != {valueOf: function() {return {}}, toString: function() {return {}}}) throw TypeError');
  } 
}
