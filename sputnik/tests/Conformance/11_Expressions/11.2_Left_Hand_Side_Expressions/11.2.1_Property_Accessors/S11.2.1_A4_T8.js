// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.2.1_A4_T8;
* @section: 11.2.1;
* @assertion: Check type of various properties;
* @description: Checking properties of the Math Object;
*/

//CHECK#1-52
if (typeof Math.E !== "number")  warn('#1: typeof Math.E === "number". Actual: ' + (typeof Math.E ));
if (typeof Math['E'] !== "number")  warn('#2: typeof Math["E"] === "number". Actual: ' + (typeof Math["E"] ));
if (typeof Math.LN10 !== "number")  warn('#3: typeof Math.LN10 === "number". Actual: ' + (typeof Math.LN10 ));
if (typeof Math['LN10'] !== "number")  warn('#4: typeof Math["LN10"] === "number". Actual: ' + (typeof Math["LN10"] ));
if (typeof Math.LN2 !== "number")  warn('#5: typeof Math.LN2 === "number". Actual: ' + (typeof Math.LN2 ));
if (typeof Math['LN2'] !== "number")  warn('#6: typeof Math["LN2"] === "number". Actual: ' + (typeof Math["LN2"] ));
if (typeof Math.LOG2E !== "number")  warn('#7: typeof Math.LOG2E === "number". Actual: ' + (typeof Math.LOG2E ));
if (typeof Math['LOG2E'] !== "number")  warn('#8: typeof Math["LOG2E"] === "number". Actual: ' + (typeof Math["LOG2E"] ));
if (typeof Math.LOG10E !== "number")  warn('#9: typeof Math.LOG10E === "number". Actual: ' + (typeof Math.LOG10E ));
if (typeof Math['LOG10E'] !== "number")  warn('#10: typeof Math["LOG10E"] === "number". Actual: ' + (typeof Math["LOG10E"] ));
if (typeof Math.PI !== "number")  warn('#11: typeof Math.PI === "number". Actual: ' + (typeof Math.PI ));
if (typeof Math['PI'] !== "number")  warn('#12: typeof Math["PI"] === "number". Actual: ' + (typeof Math["PI"] ));
if (typeof Math.SQRT1_2 !== "number")  warn('#13: typeof Math.SQRT1_2 === "number". Actual: ' + (typeof Math.SQRT1_2 ));
if (typeof Math['SQRT1_2'] !== "number")  warn('#14: typeof Math["SQRT1_2"] === "number". Actual: ' + (typeof Math["SQRT1_2"] ));
if (typeof Math.SQRT2 !== "number")  warn('#15: typeof Math.SQRT2 === "number". Actual: ' + (typeof Math.SQRT2 ));
if (typeof Math['SQRT2'] !== "number")  warn('#16: typeof Math["SQRT2"] === "number". Actual: ' + (typeof Math["SQRT2"] ));
if (typeof Math.abs !== "function")  warn('#17: typeof Math.abs === "function". Actual: ' + (typeof Math.abs ));
if (typeof Math['abs'] !== "function")  warn('#18: typeof Math["abs"] === "function". Actual: ' + (typeof Math["abs"] ));
if (typeof Math.acos !== "function")  warn('#19: typeof Math.acos === "function". Actual: ' + (typeof Math.acos ));
if (typeof Math['acos'] !== "function")  warn('#20: typeof Math["acos"] === "function". Actual: ' + (typeof Math["acos"] ));
if (typeof Math.asin !== "function")  warn('#21: typeof Math.asin === "function". Actual: ' + (typeof Math.asin ));
if (typeof Math['asin'] !== "function")  warn('#22: typeof Math["asin"] === "function". Actual: ' + (typeof Math["asin"] ));
if (typeof Math.atan !== "function")  warn('#23: typeof Math.atan === "function". Actual: ' + (typeof Math.atan ));
if (typeof Math['atan'] !== "function")  warn('#24: typeof Math["atan"] === "function". Actual: ' + (typeof Math["atan"] ));
if (typeof Math.atan2 !== "function")  warn('#25: typeof Math.atan2 === "function". Actual: ' + (typeof Math.atan2 ));
if (typeof Math['atan2'] !== "function")  warn('#26: typeof Math["atan2"] === "function". Actual: ' + (typeof Math["atan2"] ));
if (typeof Math.ceil !== "function")  warn('#27: typeof Math.ceil === "function". Actual: ' + (typeof Math.ceil ));
if (typeof Math['ceil'] !== "function")  warn('#28: typeof Math["ceil"] === "function". Actual: ' + (typeof Math["ceil"] ));
if (typeof Math.cos !== "function")  warn('#29: typeof Math.cos === "function". Actual: ' + (typeof Math.cos ));
if (typeof Math['cos'] !== "function")  warn('#30: typeof Math["cos"] === "function". Actual: ' + (typeof Math["cos"] ));
if (typeof Math.exp !== "function")  warn('#31: typeof Math.exp === "function". Actual: ' + (typeof Math.exp ));
if (typeof Math['exp'] !== "function")  warn('#32: typeof Math["exp"] === "function". Actual: ' + (typeof Math["exp"] ));
if (typeof Math.floor !== "function")  warn('#33: typeof Math.floor === "function". Actual: ' + (typeof Math.floor ));
if (typeof Math['floor'] !== "function")  warn('#34: typeof Math["floor"] === "function". Actual: ' + (typeof Math["floor"] ));
if (typeof Math.log !== "function")  warn('#35: typeof Math.log === "function". Actual: ' + (typeof Math.log ));
if (typeof Math['log'] !== "function")  warn('#36: typeof Math["log"] === "function". Actual: ' + (typeof Math["log"] ));
if (typeof Math.max !== "function")  warn('#37: typeof Math.max === "function". Actual: ' + (typeof Math.max ));
if (typeof Math['max'] !== "function")  warn('#38: typeof Math["max"] === "function". Actual: ' + (typeof Math["max"] ));
if (typeof Math.min !== "function")  warn('#39: typeof Math.min === "function". Actual: ' + (typeof Math.min ));
if (typeof Math['min'] !== "function")  warn('#40: typeof Math["min"] === "function". Actual: ' + (typeof Math["min"] ));
if (typeof Math.pow !== "function")  warn('#41: typeof Math.pow === "function". Actual: ' + (typeof Math.pow ));
if (typeof Math['pow'] !== "function")  warn('#42: typeof Math["pow"] === "function". Actual: ' + (typeof Math["pow"] ));
if (typeof Math.random !== "function")  warn('#43: typeof Math.random === "function". Actual: ' + (typeof Math.random ));
if (typeof Math['random'] !== "function")  warn('#44: typeof Math["random"] === "function". Actual: ' + (typeof Math["random"] ));
if (typeof Math.round !== "function")  warn('#45: typeof Math.round === "function". Actual: ' + (typeof Math.round ));
if (typeof Math['round'] !== "function")  warn('#46: typeof Math["round"] === "function". Actual: ' + (typeof Math["round"] ));
if (typeof Math.sin !== "function")  warn('#47: typeof Math.sin === "function". Actual: ' + (typeof Math.sin ));
if (typeof Math['sin'] !== "function")  warn('#48: typeof Math["sin"] === "function". Actual: ' + (typeof Math["sin"] ));
if (typeof Math.sqrt !== "function")  warn('#49: typeof Math.sqrt === "function". Actual: ' + (typeof Math.sqrt ));
if (typeof Math['sqrt'] !== "function")  warn('#50: typeof Math["sqrt"] === "function". Actual: ' + (typeof Math["sqrt"] ));
if (typeof Math.tan !== "function")  warn('#51: typeof Math.tan === "function". Actual: ' + (typeof Math.tan ));
if (typeof Math['tan'] !== "function")  warn('#52: typeof Math["tan"] === "function". Actual: ' + (typeof Math["tan"] ));

