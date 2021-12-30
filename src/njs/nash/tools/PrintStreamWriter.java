package nash.tools;

import java.io.PrintStream;
import java.io.PrintWriter;
import java.util.Locale;

public class PrintStreamWriter extends PrintWriter {

  public PrintStreamWriter(PrintStream out) {
    super(out,false);
    ps = out;
  }

  final PrintStream ps;

  @Override public void close() { ps.close(); }
  @Override public void flush() { ps.flush(); }

  @Override public PrintWriter append(char c) { ps.append(c); return this; }
  @Override public PrintWriter append(CharSequence csq) { ps.append(csq); return this; }
  @Override public PrintWriter append(CharSequence csq, int start, int end) { ps.append(csq,start,end); return this; }

  @Override public PrintWriter format(String format, Object... args) { ps.format(format,args); return this; }
  @Override public PrintWriter format(Locale l, String format, Object... args) { ps.format(l,format,args); return this; }

  @Override public PrintWriter printf(String format, Object... args) { ps.printf(format,args); return this; }
  @Override public PrintWriter printf(Locale l, String format, Object... args) { ps.format(l,format,args); return this; }

  @Override public boolean checkError() { return ps.checkError(); }
  @Override protected void clearError() { /*no-op*/ }
  @Override protected void setError() { /*no-op*/ }

  @Override public  void  print(boolean b) { ps.print(b); }
  @Override public  void  print(char c) { ps.print(c); }
  @Override public  void  print(char[] s) { ps.print(s); }
  @Override public  void  print(double d) { ps.print(d); }
  @Override public  void  print(float f) { ps.print(f); }
  @Override public  void  print(int i) { ps.print(i); }
  @Override public  void  print(long l) { ps.print(l); }
  @Override public  void  print(Object obj) { ps.print(obj); }
  @Override public  void  print(String s) { ps.print(s); }

  @Override public  void  println() { ps.println(); }
  @Override public  void  println(boolean x) { ps.println(x); }
  @Override public  void  println(char x) { ps.println(x); }
  @Override public  void  println(char[] x) { ps.println(x); }
  @Override public  void  println(double x) { ps.println(x); }
  @Override public  void  println(float x) { ps.println(x); }
  @Override public  void  println(int x) { ps.println(x); }
  @Override public  void  println(long x) { ps.println(x); }
  @Override public  void  println(Object x) { ps.println(x); }
  @Override public  void  println(String x) { ps.println(x); }

  @Override public  void  write(String s) { ps.append(s); }
  @Override public  void  write(String s, int off, int len) { ps.append(s,off,off+len); }

  @Override public  void  write(int c) {
    ps.print(c);
  }
  @Override public  void  write(char[] buf) {
    ps.print(buf);
  }
  @Override public  void  write(char[] buf, int off, int len) {
    len += off;
    while (off < len) ps.write(buf[off++]);
  }

}
