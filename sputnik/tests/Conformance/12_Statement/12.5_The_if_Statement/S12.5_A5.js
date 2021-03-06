// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S12.5_A5;
* @section: 12.5;
* @assertion: FunctionDeclaration inside the "if" Expression is evaluated as true and function will not be declarated;
* @description: The "if" Expression is "function __func(){throw "FunctionExpression";}";
*/

//////////////////////////////////////////////////////////////////////////////
//CHECK#1
try {
	__func=__func;
	warn('#1: "__func=__func" lead to throwing exception');
} catch (e) {
	;
}
//
//////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////
//CHECK#2
try {
	if(function __func(){throw "FunctionExpression";}) (function(){throw "TrueBranch"})(); else (function(){"MissBranch"})();
} catch (e) {
	if (e !== "TrueBranch") {
		warn('#2: Exception ==="TrueBranch". Actual:  Exception ==='+ e);
	}
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#3
try {
	__func=__func;
	warn('#3: "__func=__func" lead to throwing exception');
} catch (e) {
	;
}
//
//////////////////////////////////////////////////////////////////////////////



