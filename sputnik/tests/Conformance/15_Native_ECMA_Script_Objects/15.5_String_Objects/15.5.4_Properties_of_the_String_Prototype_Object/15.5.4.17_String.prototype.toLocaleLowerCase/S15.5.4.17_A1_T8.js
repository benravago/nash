// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.5.4.17_A1_T8;
* @section: 15.5.4.17;
* @assertion: String.prototype.toLocaleLowerCase();
* @description: Call toLocaleLowerCase() function of Infinity;
*/

Number.prototype.toLocaleLowerCase = String.prototype.toLocaleLowerCase;

if (Infinity.toLocaleLowerCase()!== "infinity") {
  warn('#1: Number.prototype.toLocaleLowerCase = String.prototype.toLocaleLowerCase; Infinity.toLocaleLowerCase()=== "infinity". Actual: '+Infinity.toLocaleLowerCase());
}
