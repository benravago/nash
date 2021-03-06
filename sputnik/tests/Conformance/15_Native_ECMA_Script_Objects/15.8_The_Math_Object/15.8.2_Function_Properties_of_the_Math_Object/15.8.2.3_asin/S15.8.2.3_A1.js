// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.8.2.3_A1;
 * @section: 15.8.2.3;
 * @assertion: If x is NaN, Math.asin(x) is NaN;
 * @description: Checking if Math.asin(NaN) is NaN;
 */
 
// CHECK#1
var x = NaN;
if (!isNaN(Math.asin(x)))
{
	warn("#1: 'var x=NaN; isNaN(Math.asin(x)) === false'");
}
