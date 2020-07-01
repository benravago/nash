// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.6.4.1_A1;
 * @section: 15.6.4.1;
 * @assertion: The initial value of Boolean.prototype.constructor is the 
 * built-in Boolean constructor;
 * @description: Compare Boolean.prototype.constructor with Boolean;
 */

//CHECK#1
if(Boolean.prototype.constructor !== Boolean){
  warn('#1: Boolean.prototype.constructor === Boolean');
}
