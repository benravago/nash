// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.2.2.1_A4_T1;
* @section: 15.2.2.1, 8.6;
* @assertion: When the Object constructor is called with one argument value and 
* the type of value is Boolean, return ToObject(boolean);
* @description: Argument value is "true";
*/


var bool = true;

//CHECK#1
if (typeof bool  !== 'boolean') {
  $FAIL('#1: true is NOT a boolean');
}

var n_obj = new Object(bool);

//CHECK#2
if (n_obj.constructor !== Boolean) {
  warn('#2: When the Object constructor is called with Boolean argument return ToObject(boolean)');
}

//CHECK#3
if (typeof n_obj !== 'object') {
  warn('#3: When the Object constructor is called with Boolean argument return ToObject(boolean)');
}

//CHECK#4
if ( n_obj != bool) {
  warn('#4: When the Object constructor is called with Boolean argument return ToObject(boolean)');
}

//CHECK#5
if ( n_obj === bool) {
  warn('#5: When the Object constructor is called with Boolean argument return ToObject(boolean)');
}
