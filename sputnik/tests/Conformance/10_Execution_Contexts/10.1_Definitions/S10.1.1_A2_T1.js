// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S10.1.1_A2_T1;
 * @section: 10.1.1;
 * @assertion: There are two types of Function objects. Internal functions 
 * are built-in objects of the language, such as parseInt and Math.exp;
 * @description: Checking types of parseInt and Math.exp;
*/

//CHECK#1
if(typeof(Math.exp)!=="function")
  warn('#1: typeof(Math.exp(10))!=="function" '+typeof(Math.exp()));

//CHECK#2
if(typeof(parseInt)!=="function")
  warn('#2: typeof(parseInt())!=="function" '+typeof(parseInt()));
  
