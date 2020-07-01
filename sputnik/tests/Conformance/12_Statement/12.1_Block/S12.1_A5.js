// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S12.1_A5;
* @section: 12.1;
* @assertion: StatementList: StatementList Statement inside the Block is evaluated from left to right;
* @description: Throwing exceptions within embedded/sequence Blocks;
*/

//////////////////////////////////////////////////////////////////////////////
//CHECK#1
try {
	throw 1;
    throw 2;
    throw 3;
    warn('1.1: throw 1 lead to throwing exception');
} catch (e) {
	if (e!==1) {
		warn('#1.2: Exception === 1. Actual:  Exception ==='+ e);
	}
}
////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#2
try {
	{
	    throw 1;
        throw 2;
    }
    throw 3;
    warn('#2.1: throw 1 lead to throwing exception');
} catch (e) {
	if (e!==1) {
		warn('#2.2: Exception === 1. Actual:  Exception ==='+ e);
	}
}
////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#3
try {
	throw 1;
    {
        throw 2;
        throw 3;
    }
    warn('#3.1: throw 1 lead to throwing exception');
} catch (e) {
	if (e!==1) {
		warn('#3.2: Exception === 1. Actual:  Exception ==='+ e);
	}
}
////////////////////////////////////////////////////////////////////////////////

