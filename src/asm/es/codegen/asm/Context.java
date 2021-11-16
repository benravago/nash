package es.codegen.asm;

class Context {

  char[] charBuffer;

  int currentMethodAccessFlags;
  String currentMethodName;
  String currentMethodDescriptor;
  Label[] currentMethodLabels;

  Label[] currentLocalVariableAnnotationRangeStarts;
  Label[] currentLocalVariableAnnotationRangeEnds;
  int[] currentLocalVariableAnnotationRangeIndices;

  int currentFrameOffset;
  int currentFrameType;
  int currentFrameLocalCount;
  int currentFrameLocalCountDelta;
  Object[] currentFrameLocalTypes;
  int currentFrameStackCount;
  Object[] currentFrameStackTypes;
}
