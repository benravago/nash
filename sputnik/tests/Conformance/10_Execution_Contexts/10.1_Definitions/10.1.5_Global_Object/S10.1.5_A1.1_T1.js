// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S10.1.5_A1.1_T1;
 * @section: 10.1.5, 15.1;
 * @assertion: Global object has properties such as built-in objects such as 
 * Math, String, Date, parseInt, etc;
 * @description: Global execution context - Value Properties;
*/

//CHECK#1
if ( NaN === null ) {
  warn("#1: NaN === null");
}

//CHECK#2
if ( Infinity === null ) {
  warn("#2: Infinity === null");
}

//CHECK#3
if ( undefined === null ) {
  warn("#3: undefined === null");
}
