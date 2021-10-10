package es.runtime;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;

import java.security.PrivilegedAction;
import java.util.zip.InflaterInputStream;
import es.ir.FunctionNode;

/**
 * This static utility class performs deserialization of FunctionNode ASTs from a byte array.
 * The format is a standard Java serialization stream, deflated.
 */
final class AstDeserializer {

  static FunctionNode deserialize(final byte[] serializedAst) {
        try {
          return (FunctionNode) new ObjectInputStream(new InflaterInputStream(
                  new ByteArrayInputStream(serializedAst))).readObject();
        } catch (final ClassNotFoundException | IOException e) {
          // This is internal, can't happen
          throw new AssertionError("Unexpected exception deserializing function", e);
        }
  }
}
