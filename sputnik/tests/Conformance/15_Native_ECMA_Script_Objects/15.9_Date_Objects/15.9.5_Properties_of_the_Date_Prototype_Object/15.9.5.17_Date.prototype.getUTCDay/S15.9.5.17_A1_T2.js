// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.9.5.17_A1_T2;
 * @section: 15.9.5.17;
 * @assertion: The Date.prototype property "getUTCDay" has { DontEnum } attributes;
 * @description: Checking absence of DontDelete attribute;
 */

if (delete Date.prototype.getUTCDay  === false) {
  warn('#1: The Date.prototype.getUTCDay property has not the attributes DontDelete');
}

if (Date.prototype.hasOwnProperty('getUTCDay')) {
  $FAIL('#2: The Date.prototype.getUTCDay property has not the attributes DontDelete');
}

