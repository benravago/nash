// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.5.4.17_A1_T3;
* @section: 15.5.4.17;
* @assertion: String.prototype.toLocaleLowerCase();
* @description: Checking by using eval;
*/

//////////////////////////////////////////////////////////////////////////////
//CHECK#1
if (eval("\"BJ\"").toLocaleLowerCase() !== "bj") {
  warn('#1: eval("\\"BJ\\"").toLocaleLowerCase() === "bj". Actual: '+eval("\"BJ\"").toLocaleLowerCase() );
}
//
//////////////////////////////////////////////////////////////////////////////
