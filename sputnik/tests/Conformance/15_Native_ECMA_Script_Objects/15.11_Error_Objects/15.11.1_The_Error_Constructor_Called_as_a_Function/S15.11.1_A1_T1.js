// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.11.1_A1_T1;
* @section: 15.11.1, 16;
* @assertion: The function call Error(...) is equivalent to the object creation expression new 
* Error(...) with the same arguments;
* @description: Checking constructor of the newly constructed Error object;
*/

//////////////////////////////////////////////////////////////////////////////
//CHECK#1
Error.prototype.toString=Object.prototype.toString;
var err1=Error();
if(err1.constructor!==Error){
  warn('#1: Error.prototype.toString=Object.prototype.toString; var err1=Error(); err1.constructor===Error. Actual: '+err1.constructor);
}
//
//////////////////////////////////////////////////////////////////////////////
