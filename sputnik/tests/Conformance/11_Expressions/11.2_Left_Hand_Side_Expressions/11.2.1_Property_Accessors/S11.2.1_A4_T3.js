// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.2.1_A4_T3;
* @section: 11.2.1;
* @assertion: Check type of various properties;
* @description: Checking properties of the Function object;
*/

//CHECK#1-8
if (typeof Function.prototype  !== "function")  warn('#1: typeof Function.prototype === "function". Actual: ' + (typeof Function.prototype ));
if (typeof Function['prototype']  !== "function")  warn('#2: typeof Function["prototype"] === "function". Actual: ' + (typeof Function["prototype"] ));
if (typeof Function.prototype.toString  !== "function")  warn('#3: typeof Function.prototype.toString === "function". Actual: ' + (typeof Function.prototype.toString ));
if (typeof Function.prototype['toString']  !== "function")  warn('#4: typeof Function.prototype["toString"] === "function". Actual: ' + (typeof Function.prototype["toString"] ));
if (typeof Function.prototype.length !== "number")  warn('#5: typeof Function.prototype.length === "number". Actual: ' + (typeof Function.prototype.length ));
if (typeof Function.prototype['length'] !== "number")  warn('#6: typeof Function.prototype["length"] === "number". Actual: ' + (typeof Function.prototype["length"] ));
if (typeof Function.prototype.valueOf  !== "function")  warn('#7: typeof Function.prototype.valueOf === "function". Actual: ' + (typeof Function.prototype.valueOf ));
if (typeof Function.prototype['valueOf']  !== "function")  warn('#8: typeof Function.prototype["valueOf"] === "function". Actual: ' + (typeof Function.prototype["valueOf"] ));
