// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.2.1_A4_T5;
* @section: 11.2.1;
* @assertion: Check type of various properties;
* @description: Checking properties of the String object;
*/

//CHECK#1-28
if (typeof String.prototype  !== "object")  warn('#1: typeof String.prototype === "object". Actual: ' + (typeof String.prototype ));
if (typeof String['prototype']  !== "object")  warn('#2: typeof String["prototype"] === "object". Actual: ' + (typeof String["prototype"] ));
if (typeof String.fromCharCode  !== "function")  warn('#3: typeof String.fromCharCode === "function". Actual: ' + (typeof String.fromCharCode ));
if (typeof String['fromCharCode']  !== "function")  warn('#4: typeof String["fromCharCode"] === "function". Actual: ' + (typeof String["fromCharCode"] ));
if (typeof String.prototype.toString  !== "function")  warn('#5: typeof String.prototype.toString === "function". Actual: ' + (typeof String.prototype.toString ));
if (typeof String.prototype['toString']  !== "function")  warn('#6: typeof String.prototype["toString"] === "function". Actual: ' + (typeof String.prototype["toString"] ));
if (typeof String.prototype.constructor  !== "function")  warn('#7: typeof String.prototype.constructor === "function". Actual: ' + (typeof String.prototype.constructor ));
if (typeof String.prototype['constructor']  !== "function")  warn('#8: typeof String.prototype["constructor"] === "function". Actual: ' + (typeof String.prototype["constructor"] ));
if (typeof String.prototype.valueOf  !== "function")  warn('#9: typeof String.prototype.valueOf === "function". Actual: ' + (typeof String.prototype.valueOf ));
if (typeof String.prototype['valueOf']  !== "function")  warn('#10: typeof String.prototype["valueOf"] === "function". Actual: ' + (typeof String.prototype["valueOf"] ));
if (typeof String.prototype.charAt !== "function")  warn('#11: typeof String.prototype.charAt === "function". Actual: ' + (typeof String.prototype.charAt ));
if (typeof String.prototype['charAt'] !== "function")  warn('#12: typeof String.prototype["charAt"] === "function". Actual: ' + (typeof String.prototype["charAt"] ));
if (typeof String.prototype.charCodeAt !== "function")  warn('#13: typeof String.prototype.charCodeAt === "function". Actual: ' + (typeof String.prototype.charCodeAt ));
if (typeof String.prototype['charCodeAt'] !== "function")  warn('#14: typeof String.prototype["charCodeAt"] === "function". Actual: ' + (typeof String.prototype["charCodeAt"] ));
if (typeof String.prototype.indexOf  !== "function")  warn('#15: typeof String.prototype.indexOf === "function". Actual: ' + (typeof String.prototype.indexOf ));
if (typeof String.prototype['indexOf']  !== "function")  warn('#16: typeof String.prototype["indexOf"] === "function". Actual: ' + (typeof String.prototype["indexOf"] ));
if (typeof String.prototype.lastIndexOf  !== "function")  warn('#17: typeof String.prototype.lastIndexOf === "function". Actual: ' + (typeof String.prototype.lastIndexOf ));
if (typeof String.prototype['lastIndexOf']  !== "function")  warn('#18: typeof String.prototype["lastIndexOf"] === "function". Actual: ' + (typeof String.prototype["lastIndexOf"] ));
if (typeof String.prototype.split !== "function")  warn('#19: typeof String.prototype.split === "function". Actual: ' + (typeof String.prototype.split ));
if (typeof String.prototype['split'] !== "function")  warn('#20: typeof String.prototype["split"] === "function". Actual: ' + (typeof String.prototype["split"] ));
if (typeof String.prototype.substring  !== "function")  warn('#21: typeof String.prototype.substring === "function". Actual: ' + (typeof String.prototype.substring ));
if (typeof String.prototype['substring']  !== "function")  warn('#22: typeof String.prototype["substring"] === "function". Actual: ' + (typeof String.prototype["substring"] ));
if (typeof String.prototype.toLowerCase !== "function")  warn('#23: typeof String.prototype.toLowerCase === "function". Actual: ' + (typeof String.prototype.toLowerCase ));
if (typeof String.prototype['toLowerCase'] !== "function")  warn('#24: typeof String.prototype["toLowerCase"] === "function". Actual: ' + (typeof String.prototype["toLowerCase"] ));
if (typeof String.prototype.toUpperCase !== "function")  warn('#25: typeof String.prototype.toUpperCase === "function". Actual: ' + (typeof String.prototype.toUpperCase ));
if (typeof String.prototype['toUpperCase'] !== "function")  warn('#26: typeof Array.prototype === "object". Actual: ' + (typeof Array.prototype ));
if (typeof String.prototype.length  !== "number")  warn('#27: typeof String.prototype.length === "number". Actual: ' + (typeof String.prototype.length ));
if (typeof String.prototype['length']  !== "number")  warn('#28: typeof String.prototype["length"] === "number". Actual: ' + (typeof String.prototype["length"] ));

