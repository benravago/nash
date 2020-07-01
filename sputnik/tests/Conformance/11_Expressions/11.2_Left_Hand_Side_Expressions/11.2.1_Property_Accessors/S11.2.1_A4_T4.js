// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.2.1_A4_T4;
* @section: 11.2.1;
* @assertion: Check type of various properties;
* @description: Checking properties of the Array object;
*/

//CHECK#1-8
if (typeof Array.prototype  !== "object")  warn('#1: typeof Array.prototype === "object". Actual: ' + (typeof Array.prototype ));
if (typeof Array['prototype'] !== "object")  warn('#2: typeof Array["prototype"] === "object". Actual: ' + (typeof Array["prototype"] ));
if (typeof Array.length  !== "number")  warn('#3: typeof Array.length === "number". Actual: ' + (typeof Array.length ));
if (typeof Array['length'] !== "number")  warn('#4: typeof Array["length"] === "number". Actual: ' + (typeof Array["length"] ));
if (typeof Array.prototype.constructor  !== "function")  warn('#5: typeof Array.prototype.constructor === "function". Actual: ' + (typeof Array.prototype.constructor ));
if (typeof Array.prototype['constructor'] !== "function")  warn('#6: typeof Array.prototype["constructor"] === "function". Actual: ' + (typeof Array.prototype["constructor"] ));
if (typeof Array.prototype.toString  !== "function")  warn('#7: typeof Array.prototype.toString === "function". Actual: ' + (typeof Array.prototype.toString ));
if (typeof Array.prototype['toString'] !== "function")  warn('#8: typeof Array.prototype["toString"] === "function". Actual: ' + (typeof Array.prototype["toString"] ));
if (typeof Array.prototype.join  !== "function")  warn('#9: typeof Array.prototype.join === "function". Actual: ' + (typeof Array.prototype.join ));
if (typeof Array.prototype['join'] !== "function")  warn('#10: typeof Array.prototype["join"] === "function". Actual: ' + (typeof Array.prototype["join"] ));
if (typeof Array.prototype.reverse  !== "function")  warn('#11: typeof Array.prototype.reverse === "function". Actual: ' + (typeof Array.prototype.reverse ));
if (typeof Array.prototype['reverse'] !== "function")  warn('#12: typeof Array.prototype["reverse"] === "function". Actual: ' + (typeof Array.prototype["reverse"] ));
if (typeof Array.prototype.sort  !== "function")  warn('#13: typeof Array.prototype.sort === "function". Actual: ' + (typeof Array.prototype.sort ));
if (typeof Array.prototype['sort'] !== "function")  warn('#14: typeof Array.prototype["sort"] === "function". Actual: ' + (typeof Array.prototype["sort"] ));

