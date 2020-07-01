// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.2.1_A4_T2;
* @section: 11.2.1;
* @assertion: Check type of various properties;
* @description: Checking properties and methods of Object objects;
*/

//CHECK#1-8
if (typeof Object.prototype  !== "object")  warn('#1: typeof Object.prototype === "object". Actual: ' + (typeof Object.prototype ));
if (typeof Object['prototype'] !== "object")  warn('#2: typeof Object["prototype"] === "object". Actual: ' + (typeof Object["prototype"] ));
if (typeof Object.toString !== "function")  warn('#3: typeof Object.toString === "function". Actual: ' + (typeof Object.toString ));
if (typeof Object['toString'] !== "function")  warn('#4: typeof Object["toString"] === "function". Actual: ' + (typeof Object["toString"] ));
if (typeof Object.valueOf !== "function")  warn('#5: typeof Object.valueOf === "function". Actual: ' + (typeof Object.valueOf ));
if (typeof Object['valueOf'] !== "function")  warn('#6: typeof Object["valueOf"] === "function". Actual: ' + (typeof Object["valueOf"] ));
if (typeof Object.constructor  !== "function")  warn('#7: typeof Object.constructor === "function". Actual: ' + (typeof Object.constructor ));
if (typeof Object['constructor'] !== "function")  warn('#8: typeof Object["constructor"] === "function". Actual: ' + (typeof Object["constructor"] ));
