package es.codegen.asm;

class Context {

  int parsingOptions;
  char[] charBuffer;

  int currentMethodAccessFlags;
  String currentMethodName;
  String currentMethodDescriptor;
  Label[] currentMethodLabels;

  int currentTypeAnnotationTarget;
  TypePath currentTypeAnnotationTargetPath;
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
