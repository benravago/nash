package es.runtime;

import java.util.zip.Deflater;
import java.util.zip.DeflaterOutputStream;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;

import es.ir.FunctionNode;
import es.runtime.options.Options;

/**
 * This static utility class performs serialization of FunctionNode ASTs to a byte array.
 * The format is a standard Java serialization stream, deflated.
 */
final class AstSerializer {

  // Experimentally, we concluded that compression level 4 gives a good tradeoff between serialization speed and size.
  private static final int COMPRESSION_LEVEL = Options.getIntProperty("nashorn.serialize.compression", 4);

  static byte[] serialize(FunctionNode fn) {
    var out = new ByteArrayOutputStream();
    var deflater = new Deflater(COMPRESSION_LEVEL);
    try (var oout = new ObjectOutputStream(new DeflaterOutputStream(out, deflater))) {
      oout.writeObject(fn);
    } catch (IOException e) {
      throw new AssertionError("Unexpected exception serializing function", e);
    } finally {
      deflater.end();
    }
    return out.toByteArray();
  }

}
