// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.9.5_A8_T1;
 * @section: 11.9.5, 11.9.6;
 * @assertion: If Type(x) is different from Type(y), return true;   
 * @description: x or y is primitive boolean;    
*/

//CHECK#1
if (!(true !== new Boolean(true))) {
  warn('#1: true !== new Number(true)');
}

//CHECK#2
if (!(true !== 1)) {
  warn('#2: true !== 1');
}

//CHECK#3
if (!(true !== new Number(true))) {
  warn('#3: true !== new Number(true)');
}

//CHECK#4
if (!(true !== "1")) {
  warn('#4: true !== "1"');
}

//CHECK#5
if (!(true !== new String(true))) {
  warn('#5: true !== new String(true)');
}

//CHECK#6
if (!(new Boolean(false) !== false)) {
  warn('#6: new Number(false) !== false');
}

//CHECK#7
if (!(0 !== false)) {
  warn('#7: 0 !== false');
}

//CHECK#8
if (!(new Number(false) !== false)) {
  warn('#8: new Number(false) !== false');
}

//CHECK#9
if (!("0" !== false)) {
  warn('#9: "0" !== false');
}

//CHECK#10
if (!(false !== new String(false))) {
  warn('#10: false !== new String(false)');
}

//CHECK#11
if (!(true !== {valueOf: function () {return true}})) {
  warn('#11: true !== {valueOf: function () {return true}}');
}
