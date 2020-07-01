// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S10.1.5_A2.1_T1;
 * @section: 10.1.5, 15.1;
 * @assertion: Global object properties have attributes { DontEnum };
 * @description: Global execution context - Value Properties;
*/

//CHECK#1
for (var x in this) {
  if ( x === 'NaN' ) {
    warn("#1: 'NaN' have attribute DontEnum");
  } else if ( x === 'Infinity' ) {
    warn("#1: 'Infinity' have attribute DontEnum");
  } else if ( x === 'undefined' ) {
    warn("#1: 'undefined' have attribute DontEnum");
  } 
}
