// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.7.3.5_A1;
 * @section: 15.7.3.5;
 * @assertion: Number.NEGATIVE_INFINITY is -Infinity;
 * @description: Checking sign and finiteness of Number.NEGATIVE_INFINITY;
*/

// CHECK#1
if (isFinite(Number.NEGATIVE_INFINITY) !== false) {
  warn('#1: Number.NEGATIVE_INFINITY === Not-a-Finite');
} else {
  if ((Number.NEGATIVE_INFINITY < 0) !== true) {
    warn('#1: Number.NEGATIVE_INFINITY === -Infinity');
  }
}
