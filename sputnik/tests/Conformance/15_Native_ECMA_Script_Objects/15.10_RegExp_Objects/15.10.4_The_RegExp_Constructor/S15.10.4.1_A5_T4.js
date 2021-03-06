// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.10.4.1_A5_T4;
* @section: 15.10.4.1;
* @assertion: If F contains any character other than 'g', 'i', or 'm', or if it contains the same one more than once, then throw a SyntaxError exception;
* @description: Checking if using "z" as F leads to throwing the correct exception;
*/

//CHECK#1
try {
	warn('#1.1: new RegExp("a|b","z") throw SyntaxError. Actual: ' + (new RegExp("a|b","z")));
} catch (e) {
	if ((e instanceof SyntaxError) !== true) {
		warn('#1.2: new RegExp("a|b","z") throw SyntaxError. Actual: ' + (e));
	}
}

