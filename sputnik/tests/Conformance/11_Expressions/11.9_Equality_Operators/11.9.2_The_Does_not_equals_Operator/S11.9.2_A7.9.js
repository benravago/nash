// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.9.2_A7.9;
 * @section: 11.9.2, 11.9.3;
 * @assertion: If Type(x) is primitive type and Type(y) is Object, 
 * return x != ToPrimitive(y);
 * @description: y is object, x is primtitive;
 */

//CHECK#1
if (({valueOf: function() {return 1}} != true) !== false) {
  warn('#1: ({valueOf: function() {return 1}} != true) === false');
}

//CHECK#2
if (({valueOf: function() {return 1}, toString: function() {return 0}} != 1) !== false) {
  warn('#2: ({valueOf: function() {return 1}, toString: function() {return 0}} != 1) === false');
}

//CHECK#3
if (({valueOf: function() {return 1}, toString: function() {return {}}} != "+1") !== false) {
  warn('#3: ({valueOf: function() {return 1}, toString: function() {return {}}} != "+1") === false');
} 
  
//CHECK#4
try {
  if (({valueOf: function() {return "+1"}, toString: function() {throw "error"}} != true) !== false) {
    warn('#4.1: ({valueOf: function() {return "+1"}, toString: function() {throw "error"}} != true) === false');
  }
}
catch (e) {
  if (e === "error") {
    warn('#4.2: ({valueOf: function() {return "+1"}, toString: function() {throw "error"}} != true) not throw "error"');
  } else {
    warn('#4.3: ({valueOf: function() {return "+1"}, toString: function() {throw "error"}} != true) not throw Error. Actual: ' + (e));
  }
}

//CHECK#5
if (({toString: function() {return "+1"}} != 1) !== false) {
  warn('#5: ({toString: function() {return "+1"}} != 1) === false');
}

//CHECK#6
if (({valueOf: function() {return {}}, toString: function() {return "+1"}} != "1") !== true) {
  warn('#6.1: ({valueOf: function() {return {}}, toString: function() {return "+1"}} != "1") === true');
} else {
  if (({valueOf: function() {return {}}, toString: function() {return "+1"}} != "+1") !== false) {
    warn('#6.2: ({valueOf: function() {return {}}, toString: function() {return "+1"}} != "+1") === false');
  }
}

//CHECK#7
try {
  ({valueOf: function() {throw "error"}, toString: function() {return 1}} != 1);
  warn('#7.1: ({valueOf: function() {throw "error"}, toString: function() {return 1}} != 1) throw "error". Actual: ' + (({valueOf: function() {throw "error"}, toString: function() {return 1}} != 1)));
}  
catch (e) {
  if (e !== "error") {
    warn('#7.2: ({valueOf: function() {throw "error"}, toString: function() {return 1}} != 1) throw "error". Actual: ' + (e));
  } 
}

//CHECK#8
try {
  ({valueOf: function() {return {}}, toString: function() {return {}}} != 1);
  warn('#8.1: ({valueOf: function() {return {}}, toString: function() {return {}}} != 1) throw TypeError. Actual: ' + (({valueOf: function() {return {}}, toString: function() {return {}}} != 1)));
}  
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#8.2: ({valueOf: function() {return {}}, toString: function() {return {}}} != 1) throw TypeError. Actual: ' + (e));
  } 
}
