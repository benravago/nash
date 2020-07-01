// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.9.5.8_A1_T2;
 * @section: 15.9.5.8;
 * @assertion: The Date.prototype property "valueOf" has { DontEnum } attributes;
 * @description: Checking absence of DontDelete attribute;
 */

if (delete Date.prototype.valueOf  === false) {
  warn('#1: The Date.prototype.valueOf property has not the attributes DontDelete');
}

if (Date.prototype.hasOwnProperty('valueOf')) {
  $FAIL('#2: The Date.prototype.valueOf property has not the attributes DontDelete');
}

