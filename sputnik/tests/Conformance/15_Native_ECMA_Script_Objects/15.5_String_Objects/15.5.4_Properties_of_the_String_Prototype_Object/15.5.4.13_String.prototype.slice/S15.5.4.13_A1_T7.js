// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.5.4.13_A1_T7;
* @section: 15.5.4.13;
* @assertion: String.prototype.slice (start, end);
* @description: Arguments are symbol and undefined, and instance is String;
*/

//since ToInteger("e") yelds 0
//////////////////////////////////////////////////////////////////////////////
//CHECK#1
if (String(void 0).slice("e",undefined) !== "undefined") {
  warn('#1: String(void 0).slice("e",undefined) === "undefined". Actual: '+String(void 0).slice("e",undefined) );
}
//
//////////////////////////////////////////////////////////////////////////////
