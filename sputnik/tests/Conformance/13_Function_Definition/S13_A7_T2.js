// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S13_A7_T2;
* @section: 13;
* @assertion: The FunctionBody must be SourceElements;
* @description: Inserting elements that is different from SourceElements into the FunctionBody;
*/

//////////////////////////////////////////////////////////////////////////////
//CHECK#1
try{
	eval("function __func(){/ ABC}");
	warn('#1: eval("function __func(){/ ABC}") lead to throwing exception');
} catch(e){
	if(!(e instanceof SyntaxError)){
		warn('#1.1: eval("function __func(){/ ABC}") lead to throwing exception of SyntaxError. Actual: exception is '+e);
	}
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#3
try{
	eval("function __func(){&1}");
	warn('#3: eval("function __func(){&1}") lead to throwing exception');
} catch(e){
	if(!(e instanceof SyntaxError)){
		warn('#3.1: eval("function __func(){&1}") lead to throwing exception of SyntaxError. Actual: exception is '+e);
	}
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#4
try{
	eval("function __func(){# ABC}");
	warn('#4: eval("function __func(){# ABC}") lead to throwing exception');
} catch(e){
	if(!(e instanceof SyntaxError)){
		warn('#4.1: eval("function __func(){# ABC}") lead to throwing exception of SyntaxError. Actual: exception is '+e);
	}
}
//
//////////////////////////////////////////////////////////////////////////////
