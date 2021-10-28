package nasgen;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import org.objectweb.asm.ClassReader;
import org.objectweb.asm.Opcodes;

/**
 * Main class for the "nasgen" tool.
 */
public class Main {

  /** ASM version to be used by nasgen tool. */
  public static final int ASM_VERSION = Opcodes.ASM7;

  private interface ErrorReporter {
    public void error(String msg);
  }

  /**
   * Public entry point for Nasgen if invoked from command line.
   * Nasgen takes three arguments in order: input directory, package list, output directory
   * @param args argument vector
   */
  public static void main(String[] args) {
    if (args.length == 3) {
      processAll(args[0], args[1], args[2], (msg) -> Main.error(msg, 1));
    } else {
      error("Usage: nasgen <input-dir> <package-list> <output-dir>", 1);
    }
  }

  static void processAll(String in, String pkgList, String out, ErrorReporter reporter) {
    var inDir = new File(in);
    if (!inDir.exists() || !inDir.isDirectory()) {
      reporter.error(in + " does not exist or not a directory");
      return;
    }
    var outDir = new File(out);
    if (!outDir.exists() || !outDir.isDirectory()) {
      reporter.error(out + " does not exist or not a directory");
      return;
    }
    var packages = pkgList.split(":");
    for (var pkg : packages) {
      pkg = pkg.replace('.', File.separatorChar);
      var dir = new File(inDir, pkg);
      for (var f : dir.listFiles()) {
        if (f.isFile() && f.getName().endsWith(".class")) {
          if (!process(f, new File(outDir, pkg), reporter)) {
            return;
          }
        }
      }
    }
  }

  static boolean process(File inFile, File outDir, ErrorReporter reporter) {
    try {
      var buf = new byte[(int) inFile.length()];
      try (var fin = new FileInputStream(inFile)) {
        fin.read(buf);
      }
      var sci = ClassGenerator.getScriptClassInfo(buf);
      if (sci != null) {
        try {
          sci.verify();
        } catch (Exception e) {
          reporter.error(e.getMessage());
          return false;
        }
        // create necessary output package dir
        outDir.mkdirs();
        // instrument @ScriptClass
        var writer = ClassGenerator.makeClassWriter();
        var reader = new ClassReader(buf);
        var inst = new ScriptClassInstrumentor(writer, sci);
        reader.accept(inst, 0);
        // write instrumented class
        try (var fos = new FileOutputStream(new File(outDir, inFile.getName()))) {
          buf = writer.toByteArray();
          fos.write(buf);
        }
        // simple class name without package prefix
        var simpleName = inFile.getName();
        simpleName = simpleName.substring(0, simpleName.indexOf(".class"));
        if (sci.isPrototypeNeeded()) {
          // generate prototype class
          var protGen = new PrototypeGenerator(sci);
          buf = protGen.getClassBytes();
          try ( FileOutputStream fos = new FileOutputStream(new File(outDir, simpleName + StringConstants.PROTOTYPE_SUFFIX + ".class"))) {
            fos.write(buf);
          }
        }
        if (sci.isConstructorNeeded()) {
          // generate constructor class
          var consGen = new ConstructorGenerator(sci);
          buf = consGen.getClassBytes();
          try (var fos = new FileOutputStream(new File(outDir, simpleName + StringConstants.CONSTRUCTOR_SUFFIX + ".class"))) {
            fos.write(buf);
          }
        }
      }
      return true;
    } catch (IOException | RuntimeException e) {
      reporter.error(e.getMessage());
      return false;
    }
  }

  static void error(String msg, int exitCode) {
    System.err.println(msg);
    System.exit(exitCode);
  }

}
