// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.6.2.1_A4;
 * @section: 15.6.2.1;
 * @assertion: The [[Class]] property of the newly constructed object 
 * is set to "Boolean";
 * @description: For testing toString function is used;
 */

delete Boolean.prototype.toString;

var obj = new Boolean();

//CHECK#1
if (obj.toString() !== "[object Boolean]") {
  warn('#1: The [[Class]] property of the newly constructed object is set to "Boolean"');
}
