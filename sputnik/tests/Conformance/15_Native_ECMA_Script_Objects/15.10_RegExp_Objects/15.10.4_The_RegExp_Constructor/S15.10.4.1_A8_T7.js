// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.10.4.1_A8_T7;
* @section: 15.10.4.1;
* @assertion: let P be ToString(pattern) and let F be ToString(flags);
* @description: Pattern is {toString:void 0, valueOf:function(){throw "invalof";} } and flags is "i";
*/

//CHECK#1
try {
	warn('#1.1: new RegExp({toString:void 0, valueOf:function(){throw "invalof";}}) throw "invalof". Actual: ' + (new RegExp({toString:void 0, valueOf:function(){throw "invalof";}})));
} catch (e) {
	if (e !== "invalof" ) {
		warn('#1.2: new RegExp({toString:void 0, valueOf:function(){throw "invalof";}}) throw "invalof". Actual: ' + (e));
	}
}

