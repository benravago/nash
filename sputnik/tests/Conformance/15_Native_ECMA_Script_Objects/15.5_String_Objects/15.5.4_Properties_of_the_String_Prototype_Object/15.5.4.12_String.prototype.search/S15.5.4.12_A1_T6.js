// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.5.4.12_A1_T6;
* @section: 15.5.4.12;
* @assertion: String.prototype.search (regexp);
* @description: Argument is x, and instance is new String, x is undefined variable;
*/

//////////////////////////////////////////////////////////////////////////////
//CHECK#1
//since ToString(undefined) evaluates to "undefined" search(undefined) evaluates to search("undefined")
if (new String("undefined").search(x) !== 0) {
  warn('#1: var x; new String("undefined").search(x) === 0. Actual: '+new String("undefined").search(x) );
}
//
//////////////////////////////////////////////////////////////////////////////

var x;
