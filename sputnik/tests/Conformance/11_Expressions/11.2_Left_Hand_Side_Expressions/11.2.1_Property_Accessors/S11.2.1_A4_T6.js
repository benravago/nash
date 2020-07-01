// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.2.1_A4_T6;
* @section: 11.2.1;
* @assertion: Check type of various properties;
* @description: Checking properties of the Boolean object;
*/

//CHECK#1-8
if (typeof Boolean.prototype  !== "object")   warn('#1: typeof Boolean.prototype === "object". Actual: ' + (typeof Boolean.prototype ));
if (typeof Boolean['prototype']  !== "object")  warn('#2: typeof Boolean["prototype"] === "object". Actual: ' + (typeof Boolean["prototype"] ));
if (typeof Boolean.constructor  !== "function")  warn('#3: typeof Boolean.constructor === "function". Actual: ' + (typeof Boolean.constructor ));
if (typeof Boolean['constructor']  !== "function")  warn('#4: typeof Boolean["constructor"] === "function". Actual: ' + (typeof Boolean["constructor"] ));
if (typeof Boolean.prototype.valueOf  !== "function")  warn('#5: typeof Boolean.prototype.valueOf === "function". Actual: ' + (typeof Boolean.prototype.valueOf ));
if (typeof Boolean.prototype['valueOf'] !== "function")  warn('#6: typeof Boolean.prototype["valueOf"] === "function". Actual: ' + (typeof Boolean.prototype["valueOf"] ));
if (typeof Boolean.prototype.toString !== "function")  warn('#7: typeof Boolean.prototype.toString === "function". Actual: ' + (typeof Boolean.prototype.toString ));
if (typeof Boolean.prototype['toString'] !== "function")  warn('#8: typeof Boolean.prototype["toString"] === "function". Actual: ' + (typeof Boolean.prototype["toString"] ));

