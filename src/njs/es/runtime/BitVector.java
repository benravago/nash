package es.runtime;

import java.util.Arrays;

/**
 * Faster implementation of BitSet
 */
public final class BitVector implements Cloneable {

  // Number of bits per slot.
  private static final int BITSPERSLOT = 64;

  // Growth quanta when resizing.
  private static final int SLOTSQUANTA = 4;

  // Shift for indexing.
  private static final int BITSHIFT = 6;

  // Mask for indexing.
  private static final int BITMASK = BITSPERSLOT - 1;

  // Bit area.
  private long[] bits;

  /**
   * Constructor.
   */
  public BitVector() {
    this.bits = new long[SLOTSQUANTA];
  }

  /**
   * Constructor
   * @param length initial length in bits
   */
  public BitVector(long length) {
    var need = (int) growthNeeded(length);
    this.bits = new long[need];
  }

  /**
   * Copy constructor
   * @param bits a bits array from another bit vector
   */
  public BitVector(long[] bits) {
    this.bits = bits.clone();
  }

  /**
   * Copy another BitVector into this one
   * @param other the source
   */
  public void copy(BitVector other) {
    bits = other.bits.clone();
  }

  /**
   * Calculate the number of slots need for the specified length of bits.
   * @param length Number of bits required.
   * @return Number of slots needed.
   */
  static long slotsNeeded(long length) {
    return (length + BITMASK) >> BITSHIFT;
  }

  /**
   * Calculate the number of slots need for the specified length of bits rounded to allocation quanta.
   * @param length Number of bits required.
   * @return Number of slots needed rounded to allocation quanta.
   */
  static long growthNeeded(long length) {
    return (slotsNeeded(length) + SLOTSQUANTA - 1) / SLOTSQUANTA * SLOTSQUANTA;
  }

  /**
   * Return a slot from bits, zero if slot is beyond length.
   * @param index Slot index.
   * @return Slot value.
   */
  long slot(int index) {
    return 0 <= index && index < bits.length ? bits[index] : 0L;
  }

  /**
   * Resize the bit vector to accommodate the new length.
   * @param length Number of bits required.
   */
  public void resize(long length) {
    var need = (int) growthNeeded(length);
    if (bits.length != need) {
      bits = Arrays.copyOf(bits, need);
    }
    var shift = (int) (length & BITMASK);
    var slot = (int) (length >> BITSHIFT);
    if (shift != 0) {
      bits[slot] &= (1L << shift) - 1;
      slot++;
    }
    for (; slot < bits.length; slot++) {
      bits[slot] = 0;
    }
  }

  /**
   * Set a bit in the bit vector.
   * @param bit Bit number.
   */
  public void set(long bit) {
    bits[(int) (bit >> BITSHIFT)] |= (1L << (int) (bit & BITMASK));
  }

  /**
   * Clear a bit in the bit vector.
   * @param bit Bit number.
   */
  public void clear(long bit) {
    bits[(int) (bit >> BITSHIFT)] &= ~(1L << (int) (bit & BITMASK));
  }

  /**
   * Toggle a bit in the bit vector.
   * @param bit Bit number.
   */
  public void toggle(long bit) {
    bits[(int) (bit >> BITSHIFT)] ^= (1L << (int) (bit & BITMASK));
  }

  /**
   * Sets all bits in the vector up to the length.
   * @param length max bit where to stop setting bits
   */
  public void setTo(long length) {
    if (0 < length) {
      var lastWord = (int) (length >> BITSHIFT);
      var lastBits = (1L << (int) (length & BITMASK)) - 1L;
      Arrays.fill(bits, 0, lastWord, ~0L);
      if (lastBits != 0L) {
        bits[lastWord] |= lastBits;
      }
    }
  }

  /**
   * Clears all bits in the vector.
   */
  public void clearAll() {
    Arrays.fill(bits, 0L);
  }

  /**
   * Test if bit is set in the bit vector.
   * @param bit Bit number.
   * @return true if bit in question is set
   */
  public boolean isSet(long bit) {
    return (bits[(int) (bit >> BITSHIFT)] & (1L << (int) (bit & BITMASK))) != 0;
  }

  /**
   * Test if a bit is clear in the bit vector.
   * @param bit Bit number.
   * @return true if bit in question is clear
   */
  public boolean isClear(long bit) {
    return (bits[(int) (bit >> BITSHIFT)] & (1L << (int) (bit & BITMASK))) == 0;
  }

  /**
   * Shift bits to the left by shift.
   * @param shift  Amount of shift.
   * @param length Length of vector after shift.
   */
  public void shiftLeft(long shift, long length) {
    if (shift != 0) {
      var leftShift = (int) (shift & BITMASK);
      var rightShift = BITSPERSLOT - leftShift;
      var slotShift = (int) (shift >> BITSHIFT);
      var slotCount = bits.length - slotShift;
      int slot, from;
      if (leftShift == 0) {
        for (slot = 0, from = slotShift; slot < slotCount; slot++, from++) {
          bits[slot] = slot(from);
        }
      } else {
        for (slot = 0, from = slotShift; slot < slotCount; slot++) {
          bits[slot] = (slot(from) >>> leftShift) | (slot(++from) << rightShift);
        }
      }
    }
    resize(length);
  }

  /**
   * Shift bits to the right by shift.
   * @param shift  Amount of shift.
   * @param length Length of vector after shift.
   */
  public void shiftRight(long shift, long length) {
    // Make room.
    resize(length);
    if (shift != 0) {
      var rightShift = (int) (shift & BITMASK);
      var leftShift = BITSPERSLOT - rightShift;
      var slotShift = (int) (shift >> BITSHIFT);
      int slot, from;
      if (leftShift == 0) {
        for (slot = bits.length, from = slot - slotShift; slot >= slotShift;) {
          slot--;
          from--;
          bits[slot] = slot(from);
        }
      } else {
        for (slot = bits.length, from = slot - slotShift; slot > 0;) {
          slot--;
          from--;
          bits[slot] = (slot(from - 1) >>> leftShift) | (slot(from) << rightShift);
        }
      }
    }
    // Mask out surplus.
    resize(length);
  }

  /**
   * Set a bit range.
   * @param fromIndex  from index (inclusive)
   * @param toIndex    to index (exclusive)
   */
  public void setRange(long fromIndex, long toIndex) {
    if (fromIndex < toIndex) {
      var firstWord = (int) (fromIndex >> BITSHIFT);
      var lastWord = (int) (toIndex - 1 >> BITSHIFT);
      var firstBits = (~0L << fromIndex);
      var lastBits = (~0L >>> -toIndex);
      if (firstWord == lastWord) {
        bits[firstWord] |= firstBits & lastBits;
      } else {
        bits[firstWord] |= firstBits;
        Arrays.fill(bits, firstWord + 1, lastWord, ~0L);
        bits[lastWord] |= lastBits;
      }
    }
  }

}
