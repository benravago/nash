// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.2.2.1_A3_T3;
* @section: 15.2.2.1, 8.6;
* @assertion: When the Object constructor is called with one argument value and 
* the type of value is String, return ToObject(string);
* @description: Argument value is sum of empty string and number;
*/

var n_obj = new Object(""+1);

//CHECK#2
if (n_obj.constructor !== String) {
  warn('#2: When the Object constructor is called with String argument return ToObject(string)');
}

//CHECK#3
if (typeof n_obj !== 'object') {
  warn('#3: When the Object constructor is called with String argument return ToObject(string)');
}

//CHECK#4
if ( n_obj != "1") {
  warn('#4: When the Object constructor is called with String argument return ToObject(string)');
}

//CHECK#5
if ( n_obj === "1") {
  warn('#5: When the Object constructor is called with String argument return ToObject(string)');
}
