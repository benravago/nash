// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.2.1_A4_T7;
* @section: 11.2.1;
* @assertion: Check type of various properties;
* @description: Checking properties of the Number object;
*/

//CHECK#1-16
if (typeof Number.MAX_VALUE  !== "number")  warn('#1: typeof Number.MAX_VALUE === "number". Actual: ' + (typeof Number.MAX_VALUE ));
if (typeof Number['MAX_VALUE'] !== "number")  warn('#2: typeof Number["MAX_VALUE"] === "number". Actual: ' + (typeof Number["MAX_VALUE"] ));
if (typeof Number.MIN_VALUE !== "number")  warn('#3: typeof Number.MIN_VALUE === "number". Actual: ' + (typeof Number.MIN_VALUE ));
if (typeof Number['MIN_VALUE'] !== "number")  warn('#4: typeof Number["MIN_VALUE"] === "number". Actual: ' + (typeof Number["MIN_VALUE"] ));
if (typeof Number.NaN !== "number")  warn('#5: typeof Number.NaN === "number". Actual: ' + (typeof Number.NaN ));
if (typeof Number['NaN'] !== "number")  warn('#6: typeof Number["NaN"] === "number". Actual: ' + (typeof Number["NaN"] ));
if (typeof Number.NEGATIVE_INFINITY !== "number")  warn('#7: typeof Number.NEGATIVE_INFINITY === "number". Actual: ' + (typeof Number.NEGATIVE_INFINITY ));
if (typeof Number['NEGATIVE_INFINITY'] !== "number")  warn('#8: typeof Number["NEGATIVE_INFINITY"] === "number". Actual: ' + (typeof Number["NEGATIVE_INFINITY"] ));
if (typeof Number.POSITIVE_INFINITY !== "number")  warn('#9: typeof Number.POSITIVE_INFINITY === "number". Actual: ' + (typeof Number.POSITIVE_INFINITY ));
if (typeof Number['POSITIVE_INFINITY'] !== "number")  warn('#10: typeof Number["POSITIVE_INFINITY"] === "number". Actual: ' + (typeof Number["POSITIVE_INFINITY"] ));
if (typeof Number.prototype.toString  !== "function")  warn('#11: typeof Number.prototype.toString === "function". Actual: ' + (typeof Number.prototype.toString ));
if (typeof Number.prototype['toString']  !== "function")  warn('#12: typeof Number.prototype["toString"] === "function". Actual: ' + (typeof Number.prototype["toString"] ));
if (typeof Number.prototype.constructor !== "function")  warn('#13: typeof Number.prototype.constructor === "function". Actual: ' + (typeof Number.prototype.constructor ));
if (typeof Number.prototype['constructor'] !== "function")  warn('#14: typeof Number.prototype["constructor"] === "function". Actual: ' + (typeof Number.prototype["constructor"] ));
if (typeof Number.prototype.valueOf  !== "function")  warn('#15: typeof Number.prototype.valueOf === "function". Actual: ' + (typeof Number.prototype.valueOf ));
if (typeof Number.prototype['valueOf']  !== "function")  warn('#16: typeof Number.prototype["valueOf"] === "function". Actual: ' + (typeof Number.prototype["valueOf"] ));


