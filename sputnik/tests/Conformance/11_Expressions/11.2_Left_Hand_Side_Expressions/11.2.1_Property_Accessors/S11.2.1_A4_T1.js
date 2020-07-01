// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.2.1_A4_T1;
* @section: 11.2.1;
* @assertion: Check type of various properties;
* @description: Checking properties of this object;
*/

//CHECK#1-32
if (typeof (this.NaN)  === "undefined")  warn('#1: typeof (this.NaN) !== "undefined"');
if (typeof this['NaN']  === "undefined")  warn('#2: typeof this["NaN"] !== "undefined"');
if (typeof this.Infinity  === "undefined")  warn('#3: typeof this.Infinity !== "undefined"');
if (typeof this['Infinity']  === "undefined")  warn('#4: typeof this["Infinity"] !== "undefined"');
if (typeof this.parseInt  === "undefined")  warn('#5: typeof this.parseInt !== "undefined"');
if (typeof this['parseInt'] === "undefined")  warn('#6: typeof this["parseInt"] !== "undefined"');
if (typeof this.parseFloat  === "undefined")  warn('#7: typeof this.parseFloat !== "undefined"');
if (typeof this['parseFloat'] === "undefined")  warn('#8: typeof this["parseFloat"] !== "undefined"');
if (typeof this.escape  === "undefined")  warn('#9: typeof this.escape !== "undefined"');
if (typeof this['escape'] === "undefined")  warn('#10: typeof this["escape"] !== "undefined"');
if (typeof this.unescape  === "undefined")  warn('#11: typeof this.unescape !== "undefined"');
if (typeof this['unescape'] === "undefined")  warn('#12: typeof this["unescape"] !== "undefined"');
if (typeof this.isNaN  === "undefined")  warn('#13: typeof this.isNaN !== "undefined"');
if (typeof this['isNaN'] === "undefined")  warn('#14: typeof this["isNaN"] !== "undefined"');
if (typeof this.isFinite  === "undefined")  warn('#15: typeof this.isFinite !== "undefined"');
if (typeof this['isFinite'] === "undefined")  warn('#16: typeof this["isFinite"] !== "undefined"');
if (typeof this.Object === "undefined")  warn('#17: typeof this.Object !== "undefined"');
if (typeof this['Object'] === "undefined")  warn('#18: typeof this["Object"] !== "undefined"');
if (typeof this.Number === "undefined")  warn('#19: typeof this.Number !== "undefined"');
if (typeof this['Number'] === "undefined")  warn('#20: typeof this["Number"] !== "undefined"');
if (typeof this.Function === "undefined")  warn('#21: typeof this.Function !== "undefined"');
if (typeof this['Function'] === "undefined")  warn('#22: typeof this["Function"] !== "undefined"');
if (typeof this.Array === "undefined")  warn('#23: typeof this.Array !== "undefined"');
if (typeof this['Array'] === "undefined")  warn('#24: typeof this["Array"] !== "undefined"');
if (typeof this.String === "undefined")  warn('#25: typeof this.String !== "undefined"');
if (typeof this['String'] === "undefined")  warn('#26: typeof this["String"] !== "undefined"');
if (typeof this.Boolean === "undefined")  warn('#27: typeof this.Boolean !== "undefined"');
if (typeof this['Boolean'] === "undefined")  warn('#28: typeof this["Boolean"] !== "undefined"');
if (typeof this.Date === "undefined")  warn('#29: typeof this.Date !== "undefined"');
if (typeof this['Date'] === "undefined")  warn('#30: typeof this["Date"] !== "undefined"');
if (typeof this.Math === "undefined")  warn('#31: typeof this.Math !== "undefined"');
if (typeof this['Math'] === "undefined")  warn('#32: typeof this["Math"] !== "undefined"');
