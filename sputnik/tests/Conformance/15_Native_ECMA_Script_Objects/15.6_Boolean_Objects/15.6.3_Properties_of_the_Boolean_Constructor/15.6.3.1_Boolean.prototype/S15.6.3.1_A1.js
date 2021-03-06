// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.6.3.1_A1;
 * @section: 15.6.3.1;
 * @assertion: The initial value of Boolean.prototype is the Boolean 
 * prototype object;
 * @description: Checking Boolean.prototype property;
 */

//CHECK#1
if (typeof Boolean.prototype !== "object") {
  warn('#1: typeof Boolean.prototype === "object"');
}

//CHECK#2
if (Boolean.prototype != false) {
  warn('#2: Boolean.prototype == false');
}

delete Boolean.prototype.toString;

if (Boolean.prototype.toString() !== "[object Boolean]") {
  warn('#3: The [[Class]] property of the Boolean prototype object is set to "Boolean"');
}
