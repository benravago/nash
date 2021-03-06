// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S12.5_A1.1_T1;
* @section: 12.5;
* @assertion: 0, null, undefined, false, empty string, NaN in expression is evaluated to false;
* @description: Using "if" without "else" construction;
*/

//////////////////////////////////////////////////////////////////////////////
//CHECK#1

if(0)
	warn('#1: 0 in expression is evaluated to false ');
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#2
if(false)
    warn('#2: false in expression is evaluated to false ');
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#3
if(null)
	warn('#3: null in expression is evaluated to false ');
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#4
if(undefined)
	warn('#4: undefined in expression is evaluated to false ');
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#5
if("")
    warn('#5: empty string in expression is evaluated to false ');
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#6
if(NaN)
    warn('#5: NaN in expression is evaluated to false ');
//
//////////////////////////////////////////////////////////////////////////////
