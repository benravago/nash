package es.codegen.asm;

class CurrentFrame extends Frame {

  CurrentFrame(Label owner) {
    super(owner);
  }

  @Override
  void execute(int opcode, int arg, Symbol symbolArg, SymbolTable symbolTable) {
    super.execute(opcode, arg, symbolArg, symbolTable);
    Frame successor = new Frame(null);
    merge(symbolTable, successor, 0);
    copyFrom(successor);
  }
}
