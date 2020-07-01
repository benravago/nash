// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S10.1.5_A2.1_T2;
 * @section: 10.1.5, 15.1;
 * @assertion: Global object properties have attributes { DontEnum };
 * @description: Global execution context - Function Properties;
*/

//CHECK#1
for (var x in this) {
  if ( x === 'eval' ) {
    warn("#1: 'eval' have attribute DontEnum");
  } else if ( x === 'parseInt' ) {
    warn("#1: 'parseInt' have attribute DontEnum");
  } else if ( x === 'parseFloat' ) {
    warn("#1: 'parseFloat' have attribute DontEnum");
  } else if ( x === 'isNaN' ) {
    warn("#1: 'isNaN' have attribute DontEnum");
  } else if ( x === 'isFinite' ) {
    warn("#1: 'isFinite' have attribute DontEnum");
  } else if ( x === 'decodeURI' ) {
    warn("#1: 'decodeURI' have attribute DontEnum");
  } else if ( x === 'decodeURIComponent' ) {
    warn("#1: 'decodeURIComponent' have attribute DontEnum");
  } else if ( x === 'encodeURI' ) {
    warn("#1: 'encodeURI' have attribute DontEnum");
  } else if ( x === 'encodeURIComponent' ) {
    warn("#1: 'encodeURIComponent' have attribute DontEnum");
  } 
}
