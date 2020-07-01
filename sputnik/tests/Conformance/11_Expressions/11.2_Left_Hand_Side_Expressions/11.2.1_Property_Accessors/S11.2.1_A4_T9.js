// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.2.1_A4_T9;
* @section: 11.2.1;
* @assertion: Check type of various properties;
* @description: Checking properties of the Date object;
*/

//CHECK#1-86
if (typeof Date.parse !== "function")  warn('#1: typeof Date.parse === "function". Actual: ' + (typeof Date.parse ));
if (typeof Date['parse'] !== "function")  warn('#2: typeof Date["parse"] === "function". Actual: ' + (typeof Date["parse"] ));
if (typeof Date.prototype !== "object")  warn('#3: typeof Date.prototype === "object". Actual: ' + (typeof Date.prototype ));
if (typeof Date['prototype'] !== "object")  warn('#4: typeof Date["prototype"] === "object". Actual: ' + (typeof Date["prototype"] ));
if (typeof Date.UTC !== "function")  warn('#5: typeof Date.UTC === "function". Actual: ' + (typeof Date.UTC ));
if (typeof Date['UTC'] !== "function")  warn('#6: typeof Date["UTC"] === "function". Actual: ' + (typeof Date["UTC"] ));
if (typeof Date.prototype.constructor !== "function")  warn('#7: typeof Date.prototype.constructor === "funvtion". Actual: ' + (typeof Date.prototype.constructor ));
if (typeof Date.prototype['constructor'] !== "function")  warn('#8: typeof Date.prototype["constructor"] === "function". Actual: ' + (typeof Date.prototype["constructor"] ));
if (typeof Date.prototype.toString !== "function")  warn('#9: typeof Date.prototype.toString === "function". Actual: ' + (typeof Date.prototype.toString ));
if (typeof Date.prototype['toString'] !== "function")  warn('#10: typeof Date.prototype["toString"] === "function". Actual: ' + (typeof Date.prototype["toString"] ));
if (typeof Date.prototype.valueOf !== "function")  warn('#11: typeof Date.prototype.valueOf === "function". Actual: ' + (typeof Date.prototype.valueOf ));
if (typeof Date.prototype['valueOf'] !== "function")  warn('#12: typeof Date.prototype["valueOf"] === "function". Actual: ' + (typeof Date.prototype["valueOf"] ));
if (typeof Date.prototype.getTime !== "function")  warn('#13: typeof Date.prototype.getTime === "function". Actual: ' + (typeof Date.prototype.getTime ));
if (typeof Date.prototype['getTime'] !== "function")  warn('#14: typeof Date.prototype["getTime"] === "function". Actual: ' + (typeof Date.prototype["getTime"] ));
if (typeof Date.prototype.getYear !== "function")  warn('#15: typeof Date.prototype.getYear === "function". Actual: ' + (typeof Date.prototype.getYear ));
if (typeof Date.prototype['getYear'] !== "function")  warn('#16: typeof Date.prototype["getYear"] === "function". Actual: ' + (typeof Date.prototype["getYear"] ));
if (typeof Date.prototype.getFullYear !== "function")  warn('#17: typeof Date.prototype.getFullYear === "function". Actual: ' + (typeof Date.prototype.getFullYear ));
if (typeof Date.prototype['getFullYear'] !== "function")  warn('#18: typeof Date.prototype["getFullYear"] === "function". Actual: ' + (typeof Date.prototype["getFullYear"] ));
if (typeof Date.prototype.getUTCFullYear !== "function")  warn('#19: typeof Date.prototype.getUTCFullYear === "function". Actual: ' + (typeof Date.prototype.getUTCFullYear ));
if (typeof Date.prototype['getUTCFullYear'] !== "function")  warn('#20: typeof Date.prototype["getUTCFullYear"] === "function". Actual: ' + (typeof Date.prototype["getUTCFullYear"] ));
if (typeof Date.prototype.getMonth !== "function")  warn('#21: typeof Date.prototype.getMonth === "function". Actual: ' + (typeof Date.prototype.getMonth ));
if (typeof Date.prototype['getMonth'] !== "function")  warn('#22: typeof Date.prototype["getMonth"] === "function". Actual: ' + (typeof Date.prototype["getMonth"] ));
if (typeof Date.prototype.getUTCMonth !== "function")  warn('#23: typeof Date.prototype.getUTCMonth === "function". Actual: ' + (typeof Date.prototype.getUTCMonth ));
if (typeof Date.prototype['getUTCMonth'] !== "function")  warn('#24: typeof Date.prototype["getUTCMonth"] === "function". Actual: ' + (typeof Date.prototype["getUTCMonth"] ));
if (typeof Date.prototype.getDate !== "function")  warn('#25: typeof Date.prototype.getDate === "function". Actual: ' + (typeof Date.prototype.getDate ));
if (typeof Date.prototype['getDate'] !== "function")  warn('#26: typeof Date.prototype["getDate"] === "function". Actual: ' + (typeof Date.prototype["getDate"] ));
if (typeof Date.prototype.getUTCDate !== "function")  warn('#27: typeof Date.prototype.getUTCDate === "function". Actual: ' + (typeof Date.prototype.getUTCDate ));
if (typeof Date.prototype['getUTCDate'] !== "function")  warn('#28: typeof Date.prototype["getUTCDate"] === "function". Actual: ' + (typeof Date.prototype["getUTCDate"] ));
if (typeof Date.prototype.getDay !== "function")  warn('#29: typeof Date.prototype.getDay === "function". Actual: ' + (typeof Date.prototype.getDay ));
if (typeof Date.prototype['getDay'] !== "function")  warn('#30: typeof Date.prototype["getDay"] === "function". Actual: ' + (typeof Date.prototype["getDay"] ));
if (typeof Date.prototype.getUTCDay !== "function")  warn('#31: typeof Date.prototype.getUTCDay === "function". Actual: ' + (typeof Date.prototype.getUTCDay ));
if (typeof Date.prototype['getUTCDay'] !== "function")  warn('#32: typeof Date.prototype["getUTCDay"] === "function". Actual: ' + (typeof Date.prototype["getUTCDay"] ));
if (typeof Date.prototype.getHours !== "function")  warn('#33: typeof Date.prototype.getHours === "function". Actual: ' + (typeof Date.prototype.getHours ));
if (typeof Date.prototype['getHours'] !== "function")  warn('#34: typeof Date.prototype["getHours"] === "function". Actual: ' + (typeof Date.prototype["getHours"] ));
if (typeof Date.prototype.getUTCHours !== "function")  warn('#35: typeof Date.prototype.getUTCHours === "function". Actual: ' + (typeof Date.prototype.getUTCHours ));
if (typeof Date.prototype['getUTCHours'] !== "function")  warn('#36: typeof Date.prototype["getUTCHours"] === "function". Actual: ' + (typeof Date.prototype["getUTCHours"] ));
if (typeof Date.prototype.getMinutes !== "function")  warn('#37: typeof Date.prototype.getMinutes === "function". Actual: ' + (typeof Date.prototype.getMinutes ));
if (typeof Date.prototype['getMinutes'] !== "function")  warn('#38: typeof Date.prototype["getMinutes"] === "function". Actual: ' + (typeof Date.prototype["getMinutes"] ));
if (typeof Date.prototype.getUTCMinutes !== "function")  warn('#39: typeof Date.prototype.getUTCMinutes === "function". Actual: ' + (typeof Date.prototype.getUTCMinutes ));
if (typeof Date.prototype['getUTCMinutes'] !== "function")  warn('#40: typeof Date.prototype["getUTCMinutes"] === "function". Actual: ' + (typeof Date.prototype["getUTCMinutes"] ));
if (typeof Date.prototype.getSeconds !== "function")  warn('#41: typeof Date.prototype.getSeconds === "function". Actual: ' + (typeof Date.prototype.getSeconds ));
if (typeof Date.prototype['getSeconds'] !== "function")  warn('#42: typeof Date.prototype["getSeconds"] === "function". Actual: ' + (typeof Date.prototype["getSeconds"] ));
if (typeof Date.prototype.getUTCSeconds !== "function")  warn('#43: typeof Date.prototype.getUTCSeconds === "function". Actual: ' + (typeof Date.prototype.getUTCSeconds ));
if (typeof Date.prototype['getUTCSeconds'] !== "function")  warn('#44: typeof Date.prototype["getUTCSeconds"] === "function". Actual: ' + (typeof Date.prototype["getUTCSeconds"] ));
if (typeof Date.prototype.getMilliseconds !== "function")  warn('#45: typeof Date.prototype.getMilliseconds === "function". Actual: ' + (typeof Date.prototype.getMilliseconds ));
if (typeof Date.prototype['getMilliseconds'] !== "function")  warn('#46: typeof Date.prototype["getMilliseconds"] === "function". Actual: ' + (typeof Date.prototype["getMilliseconds"] ));
if (typeof Date.prototype.getUTCMilliseconds !== "function")  warn('#47: typeof Date.prototype.getUTCMilliseconds === "function". Actual: ' + (typeof Date.prototype.getUTCMilliseconds ));
if (typeof Date.prototype['getUTCMilliseconds'] !== "function")  warn('#48: typeof Date.prototype["getUTCMilliseconds"] === "function". Actual: ' + (typeof Date.prototype["getUTCMilliseconds"] ));
if (typeof Date.prototype.setTime !== "function")  warn('#49: typeof Date.prototype.setTime === "function". Actual: ' + (typeof Date.prototype.setTime ));
if (typeof Date.prototype['setTime'] !== "function")  warn('#50: typeof Date.prototype["setTime"] === "function". Actual: ' + (typeof Date.prototype["setTime"] ));
if (typeof Date.prototype.setMilliseconds !== "function")  warn('#51: typeof Date.prototype.setMilliseconds === "function". Actual: ' + (typeof Date.prototype.setMilliseconds ));
if (typeof Date.prototype['setMilliseconds'] !== "function")  warn('#52: typeof Date.prototype["setMilliseconds"] === "function". Actual: ' + (typeof Date.prototype["setMilliseconds"] ));
if (typeof Date.prototype.setUTCMilliseconds !== "function")  warn('#53: typeof Date.prototype.setUTCMilliseconds === "function". Actual: ' + (typeof Date.prototype.setUTCMilliseconds ));
if (typeof Date.prototype['setUTCMilliseconds'] !== "function")  warn('#54: typeof Date.prototype["setUTCMilliseconds"] === "function". Actual: ' + (typeof Date.prototype["setUTCMilliseconds"] ));
if (typeof Date.prototype.setSeconds !== "function")  warn('#55: typeof Date.prototype.setSeconds === "function". Actual: ' + (typeof Date.prototype.setSeconds ));
if (typeof Date.prototype['setSeconds'] !== "function")  warn('#56: typeof Date.prototype["setSeconds"] === "function". Actual: ' + (typeof Date.prototype["setSeconds"] ));
if (typeof Date.prototype.setUTCSeconds !== "function")  warn('#57: typeof Date.prototype.setUTCSeconds === "function". Actual: ' + (typeof Date.prototype.setUTCSeconds ));
if (typeof Date.prototype['setUTCSeconds'] !== "function")  warn('#58: typeof Date.prototype["setUTCSeconds"] === "function". Actual: ' + (typeof Date.prototype["setUTCSeconds"] ));
if (typeof Date.prototype.setMinutes !== "function")  warn('#59: typeof Date.prototype.setMinutes === "function". Actual: ' + (typeof Date.prototype.setMinutes ));
if (typeof Date.prototype['setMinutes'] !== "function")  warn('#60: typeof Date.prototype["setMinutes"] === "function". Actual: ' + (typeof Date.prototype["setMinutes"] ));
if (typeof Date.prototype.setUTCMinutes !== "function")  warn('#61: typeof Date.prototype.setUTCMinutes === "function". Actual: ' + (typeof Date.prototype.setUTCMinutes ));
if (typeof Date.prototype['setUTCMinutes'] !== "function")  warn('#62: typeof Date.prototype["setUTCMinutes"] === "function". Actual: ' + (typeof Date.prototype["setUTCMinutes"] ));
if (typeof Date.prototype.setHours !== "function")  warn('#63: typeof Date.prototype.setHours === "function". Actual: ' + (typeof Date.prototype.setHours ));
if (typeof Date.prototype['setHours'] !== "function")  warn('#64: typeof Date.prototype["setHours"] === "function". Actual: ' + (typeof Date.prototype["setHours"] ));
if (typeof Date.prototype.setUTCHours !== "function")  warn('#65: typeof Date.prototype.setUTCHours === "function". Actual: ' + (typeof Date.prototype.setUTCHours ));
if (typeof Date.prototype['setUTCHours'] !== "function")  warn('#66: typeof Date.prototype["setUTCHours"] === "function". Actual: ' + (typeof Date.prototype["setUTCHours"] ));
if (typeof Date.prototype.setDate !== "function")  warn('#67: typeof Date.prototype.setDate === "function". Actual: ' + (typeof Date.prototype.setDate ));
if (typeof Date.prototype['setDate'] !== "function")  warn('#68: typeof Date.prototype["setDate"] === "function". Actual: ' + (typeof Date.prototype["setDate"] ));
if (typeof Date.prototype.setUTCDate !== "function")  warn('#69: typeof Date.prototype.setUTCDate === "function". Actual: ' + (typeof Date.prototype.setUTCDate ));
if (typeof Date.prototype['setUTCDate'] !== "function")  warn('#70: typeof Date.prototype["setUTCDate"] === "function". Actual: ' + (typeof Date.prototype["setUTCDate"] ));
if (typeof Date.prototype.setMonth !== "function")  warn('#71: typeof Date.prototype.setMonth === "function". Actual: ' + (typeof Date.prototype.setMonth ));
if (typeof Date.prototype['setMonth'] !== "function")  warn('#72: typeof Date.prototype["setMonth"] === "function". Actual: ' + (typeof Date.prototype["setMonth"] ));
if (typeof Date.prototype.setUTCMonth !== "function")  warn('#73: typeof Date.prototype.setUTCMonth === "function". Actual: ' + (typeof Date.prototype.setUTCMonth ));
if (typeof Date.prototype['setUTCMonth'] !== "function")  warn('#74: typeof Date.prototype["setUTCMonth"] === "function". Actual: ' + (typeof Date.prototype["setUTCMonth"] ));
if (typeof Date.prototype.setFullYear !== "function")  warn('#75: typeof Date.prototype.setFullYear === "function". Actual: ' + (typeof Date.prototype.setFullYear ));
if (typeof Date.prototype['setFullYear'] !== "function")  warn('#76: typeof Date.prototype["setFullYear"] === "function". Actual: ' + (typeof Date.prototype["setFullYear"] ));
if (typeof Date.prototype.setUTCFullYear !== "function")  warn('#77: typeof Date.prototype.setUTCFullYear === "function". Actual: ' + (typeof Date.prototype.setUTCFullYear ));
if (typeof Date.prototype['setUTCFullYear'] !== "function")  warn('#78: typeof Date.prototype["setUTCFullYear"] === "function". Actual: ' + (typeof Date.prototype["setUTCFullYear"] ));
if (typeof Date.prototype.setYear !== "function")  warn('#79: typeof Date.prototype.setYear === "function". Actual: ' + (typeof Date.prototype.setYear ));
if (typeof Date.prototype['setYear'] !== "function")  warn('#80: typeof Date.prototype["setYear"] === "function". Actual: ' + (typeof Date.prototype["setYear"] ));
if (typeof Date.prototype.toLocaleString !== "function")  warn('#81: typeof Date.prototype.toLocaleString === "function". Actual: ' + (typeof Date.prototype.toLocaleString ));
if (typeof Date.prototype['toLocaleString'] !== "function")  warn('#82: typeof Date.prototype["toLocaleString"] === "function". Actual: ' + (typeof Date.prototype["toLocaleString"] ));
if (typeof Date.prototype.toUTCString !== "function")  warn('#83: typeof Date.prototype.toUTCString === "function". Actual: ' + (typeof Date.prototype.toUTCString ));
if (typeof Date.prototype['toUTCString'] !== "function")  warn('#84: typeof Date.prototype["toUTCString"] === "function". Actual: ' + (typeof Date.prototype["toUTCString"] ));
if (typeof Date.prototype.toGMTString !== "function")  warn('#85: typeof Date.prototype.toGMTString === "function". Actual: ' + (typeof Date.prototype.toGMTString ));
if (typeof Date.prototype['toGMTString'] !== "function")  warn('#86: typeof Date.prototype["toGMTString"] === "function". Actual: ' + (typeof Date.prototype["toGMTString"] ));



