// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.8.6_A5_T2;
* @section: 11.8.6;
* @assertion: TypeError is subclass of Error from instanceof operator point of view;
* @description: Checking TypeError case;
*/

var __t__err = new TypeError;

//CHECK#1
if (!(__t__err instanceof Error)) {
	warn('#1: TypeError is subclass of Error from instanceof operator poit of view');
}

//CHECK#2
if (!(__t__err instanceof TypeError)) {
	warn('#2: TypeError is subclass of Error from instanceof operator poit of view');
}

//////////////////////////////////////////////////////////////////////////////
var err__t__ = TypeError('failed');

//CHECK#3
if (!(err__t__ instanceof Error)) {
	warn('#3: TypeError is subclass of Error from instanceof operator poit of view');
}

//CHECK#4
if (!(err__t__ instanceof TypeError)) {
	warn('#4: TypeError is subclass of Error from instanceof operator poit of view');
}

