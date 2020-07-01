// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S10.1.5_A1.1_T2;
 * @section: 10.1.5, 15.1;
 * @assertion: Global object has properties such as built-in objects such as 
 * Math, String, Date, parseInt, etc;
 * @description: Global execution context - Function Properties;
*/

//CHECK#4
if ( eval === null ) {
  warn("#4: eval === null");
}

//CHECK#5
if ( parseInt === null ) {
  warn("#5: parseInt === null");
}

//CHECK#6
if ( parseFloat === null ) {
  warn("#6: parseFloat === null");
}

//CHECK#7
if ( isNaN === null ) {
  warn("#7: isNaN === null");
}

//CHECK#8
if ( isFinite === null ) {
  warn("#8: isFinite === null");
}

//CHECK#9
if ( decodeURI === null ) {
  warn("#9: decodeURI === null");
}

//CHECK#10
if ( decodeURIComponent === null ) {
  warn("#10: decodeURIComponent === null");
}

//CHECK#11
if ( encodeURI === null ) {
  warn("#11: encodeURI === null");
}

//CHECK#12
if ( encodeURIComponent === null ) {
  warn("#12: encodeURIComponent === null");
}
