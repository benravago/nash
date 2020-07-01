// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.2.1.1_A1_T5;
* @section: 15.2.1.1, 15.2.2.1;
* @assertion: When the Object(value) is called and the value is null, undefined or not supplied, 
* create and return a new Object object if the object constructor had been called with the same arguments (15.2.2.1);
* @description: Creating Object(x) and checking its properties;
*/

var __obj = Object(x);

var n__obj = new Object(x); 

if (__obj.toString() !== n__obj.toString()){
	warn('#1');	
}

if (__obj.constructor !== n__obj.constructor) {
	warn('#2');
}

if (__obj.prototype !== n__obj.prototype) {
	warn('#3');
}	

if (__obj.toLocaleString() !== n__obj.toLocaleString()) {
	warn('#4');
}

if (typeof __obj !== typeof n__obj) {
	warn('#5');
}

var x;
