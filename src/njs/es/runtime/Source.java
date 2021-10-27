package es.runtime;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Base64;
import java.util.Objects;
import java.util.WeakHashMap;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOError;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.Reader;

import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import java.lang.ref.WeakReference;

import nash.scripting.URLReader;

import es.parser.Token;
import es.runtime.logging.DebugLogger;
import es.runtime.logging.Loggable;
import es.runtime.logging.Logger;

/**
 * Source objects track the origin of JavaScript entities.
 */
@Logger(name = "source")
public final class Source implements Loggable {

  private static final int BUF_SIZE = 8 * 1024;
  private static final Cache CACHE = new Cache();

  // Message digest to file name encoder
  private final static Base64.Encoder BASE64 = Base64.getUrlEncoder().withoutPadding();

  // Descriptive name of the source as supplied by the user.
  // Used for error reporting to the user.
  // For example, SyntaxError will use this to print message.
  // Used to implement __FILE__. Also used for SourceFile in .class for debugger usage.
  private final String name;

  // Base path or URL of this source.
  // Used to implement __DIR__, which can be used to load scripts relative to the location of the current script.
  // This will be null when it can't be computed.
  private final String base;

  // Source content
  private final Data data;

  // Cached hash code
  private int hash;

  // Base64-encoded SHA1 digest of this source object
  private volatile byte[] digest;

  // source URL set via //@ sourceURL or //# sourceURL directive
  private String explicitURL;

  // Do *not* make this public, ever! Trusts the URL and content.
  Source(String name, String base, Data data) {
    this.name = name;
    this.base = base;
    this.data = data;
  }

  static synchronized Source sourceFor(String name, String base, URLData data) throws IOException {
    try {
      var newSource = new Source(name, base, data);
      var existingSource = CACHE.get(newSource);
      if (existingSource != null) {
        // Force any access errors
        data.checkPermissionAndClose();
        return existingSource;
      }
      // All sources in cache must be fully loaded
      data.load();
      CACHE.put(newSource, newSource);
      return newSource;
    } catch (RuntimeException e) {
      var cause = e.getCause();
      if (cause instanceof IOException) {
        throw (IOException) cause;
      }
      throw e;
    }
  }

  static class Cache extends WeakHashMap<Source, WeakReference<Source>> {

    public Source get(Source key) {
      var ref = super.get(key);
      return ref == null ? null : ref.get();
    }

    public void put(Source key, Source value) {
      assert !(value.data instanceof RawData);
      put(key, new WeakReference<>(value));
    }
  }

  // Wrapper to manage lazy loading
  static interface Data {
    URL url();
    int length();
    long lastModified();
    char[] array();
    boolean isEvalCode();
  }

  static class RawData implements Data {

    private final char[] array;
    private final boolean evalCode;
    private int hash;

    RawData(char[] array, boolean evalCode) {
      this.array = Objects.requireNonNull(array);
      this.evalCode = evalCode;
    }

    RawData(String source, boolean evalCode) {
      this.array = Objects.requireNonNull(source).toCharArray();
      this.evalCode = evalCode;
    }

    RawData(Reader reader) throws IOException {
      this(readFully(reader), false);
    }

    @Override
    public int hashCode() {
      var h = hash;
      if (h == 0) {
        h = hash = Arrays.hashCode(array) ^ (evalCode ? 1 : 0);
      }
      return h;
    }

    @Override
    public boolean equals(Object obj) {
      if (this == obj) {
        return true;
      }
      if (obj instanceof RawData other) {
        return Arrays.equals(array, other.array) && evalCode == other.evalCode;
      }
      return false;
    }

    @Override
    public String toString() {
      return new String(array());
    }

    @Override
    public URL url() {
      return null;
    }

    @Override
    public int length() {
      return array.length;
    }

    @Override
    public long lastModified() {
      return 0;
    }

    @Override
    public char[] array() {
      return array;
    }

    @Override
    public boolean isEvalCode() {
      return evalCode;
    }
  }

  static class URLData implements Data {

    private final URL url;
    protected final Charset cs;
    private int hash;
    protected char[] array;
    protected int length;
    protected long lastModified;

    URLData(URL url, Charset cs) {
      this.url = Objects.requireNonNull(url);
      this.cs = cs;
    }

    @Override
    public int hashCode() {
      var h = hash;
      if (h == 0) {
        h = hash = url.hashCode();
      }
      return h;
    }

    @Override
    public boolean equals(Object other) {
      if (this == other) {
        return true;
      }
      if (other instanceof URLData otherData) {
        if (url.equals(otherData.url)) {
          // Make sure both have meta data loaded
          try {
            if (isDeferred()) {
              // Data in cache is always loaded, and we only compare to cached data.
              assert !otherData.isDeferred();
              loadMeta();
            } else if (otherData.isDeferred()) {
              otherData.loadMeta();
            }
          } catch (IOException e) {
            throw new RuntimeException(e);
          }
          // Compare meta data
          return this.length == otherData.length && this.lastModified == otherData.lastModified;
        }
      }
      return false;
    }

    @Override
    public String toString() {
      return new String(array());
    }

    @Override
    public URL url() {
      return url;
    }

    @Override
    public int length() {
      return length;
    }

    @Override
    public long lastModified() {
      return lastModified;
    }

    @Override
    public char[] array() {
      assert !isDeferred();
      return array;
    }

    @Override
    public boolean isEvalCode() {
      return false;
    }

    boolean isDeferred() {
      return array == null;
    }

    @SuppressWarnings("try")
    protected void checkPermissionAndClose() throws IOException {
      try (var in = url.openStream()) {
        // empty
      }
      debug("permission checked for ", url);
    }

    protected void load() throws IOException {
      if (array == null) {
        var c = url.openConnection();
        try (var in = c.getInputStream()) {
          array = cs == null ? readFully(in) : readFully(in, cs);
          length = array.length;
          lastModified = c.getLastModified();
          debug("loaded content for ", url);
        }
      }
    }

    @SuppressWarnings("try")
    protected void loadMeta() throws IOException {
      if (length == 0 && lastModified == 0) {
        var c = url.openConnection();
        try (var in = c.getInputStream()) {
          length = c.getContentLength();
          lastModified = c.getLastModified();
          debug("loaded metadata for ", url);
        }
      }
    }
  }

  static class FileData extends URLData {

    private final File file;

    FileData(File file, Charset cs) {
      super(getURLFromFile(file), cs);
      this.file = file;
    }

    @Override
    protected void checkPermissionAndClose() throws IOException {
      if (!file.canRead()) {
        throw new FileNotFoundException(file + " (Permission Denied)");
      }
      debug("permission checked for ", file);
    }

    @Override
    protected void loadMeta() {
      if (length == 0 && lastModified == 0) {
        length = (int) file.length();
        lastModified = file.lastModified();
        debug("loaded metadata for ", file);
      }
    }

    @Override
    protected void load() throws IOException {
      if (array == null) {
        array = cs == null ? readFully(file) : readFully(file, cs);
        length = array.length;
        lastModified = file.lastModified();
        debug("loaded content for ", file);
      }
    }
  }

  static void debug(Object... msg) {
    var logger = getLoggerStatic();
    if (logger != null) {
      logger.info(msg);
    }
  }

  char[] data() {
    return data.array();
  }

  /**
   * Returns a Source instance
   * @param name    source name
   * @param content contents as char array
   * @param isEval does this represent code from 'eval' call?
   * @return source instance
   */
  public static Source sourceFor(String name, char[] content, boolean isEval) {
    return new Source(name, baseName(name), new RawData(content, isEval));
  }

  /**
   * Returns a Source instance
   * @param name    source name
   * @param content contents as char array
   * @return source instance
   */
  public static Source sourceFor(String name, char[] content) {
    return sourceFor(name, content, false);
  }

  /**
   * Returns a Source instance
   * @param name    source name
   * @param content contents as string
   * @param isEval does this represent code from 'eval' call?
   * @return source instance
   */
  public static Source sourceFor(String name, String content, boolean isEval) {
    return new Source(name, baseName(name), new RawData(content, isEval));
  }

  /**
   * Returns a Source instance
   * @param name    source name
   * @param content contents as string
   * @return source instance
   */
  public static Source sourceFor(String name, String content) {
    return sourceFor(name, content, false);
  }

  /**
   * Constructor
   * @param name  source name
   * @param url   url from which source can be loaded
   * @return source instance
   * @throws IOException if source cannot be loaded
   */
  public static Source sourceFor(String name, URL url) throws IOException {
    return sourceFor(name, url, null);
  }

  /**
   * Constructor
   * @param name  source name
   * @param url   url from which source can be loaded
   * @param cs    Charset used to convert bytes to chars
   * @return source instance
   * @throws IOException if source cannot be loaded
   */
  public static Source sourceFor(String name, URL url, Charset cs) throws IOException {
    return sourceFor(name, baseURL(url), new URLData(url, cs));
  }

  /**
   * Constructor
   * @param name  source name
   * @param file  file from which source can be loaded
   * @return source instance
   * @throws IOException if source cannot be loaded
   */
  public static Source sourceFor(String name, File file) throws IOException {
    return sourceFor(name, file, null);
  }

  /**
   * Constructor
   * @param name  source name
   * @param path  path from which source can be loaded
   * @return source instance
   * @throws IOException if source cannot be loaded
   */
  public static Source sourceFor(String name, Path path) throws IOException {
    File file = null;
    try {
      file = path.toFile();
    } catch (UnsupportedOperationException uoe) {} // TODO: review; questionable use of path.toFile()
    return (file != null) ? sourceFor(name, file) : sourceFor(name, Files.newBufferedReader(path));
  }

  /**
   * Constructor
   * @param name  source name
   * @param file  file from which source can be loaded
   * @param cs    Charset used to convert bytes to chars
   * @return source instance
   * @throws IOException if source cannot be loaded
   */
  public static Source sourceFor(String name, File file, Charset cs) throws IOException {
    var absFile = file.getAbsoluteFile();
    return sourceFor(name, dirName(absFile, null), new FileData(file, cs));
  }

  /**
   * Returns an instance
   * @param name source name
   * @param reader reader from which source can be loaded
   * @return source instance
   * @throws IOException if source cannot be loaded
   */
  public static Source sourceFor(String name, Reader reader) throws IOException {
    // Extract URL from URLReader to defer loading and reuse cached data if available.
    return (reader instanceof URLReader urlReader) ? sourceFor(name, urlReader.getURL(), urlReader.getCharset()) : new Source(name, baseName(name), new RawData(reader));
  }

  @Override
  public boolean equals(Object obj) {
    if (this == obj) {
      return true;
    }
    if (!(obj instanceof Source)) {
      return false;
    }
    var other = (Source) obj;
    return Objects.equals(name, other.name) && data.equals(other.data);
  }

  @Override
  public int hashCode() {
    var h = hash;
    if (h == 0) {
      h = hash = data.hashCode() ^ Objects.hashCode(name);
    }
    return h;
  }

  /**
   * Fetch source content.
   * @return Source content.
   */
  public String getString() {
    return data.toString();
  }

  /**
   * Get the user supplied name of this script.
   * @return User supplied source name.
   */
  public String getName() {
    return name;
  }

  /**
   * Get the last modified time of this script.
   * @return Last modified time.
   */
  public long getLastModified() {
    return data.lastModified();
  }

  /**
   * Get the "directory" part of the file or "base" of the URL.
   * @return base of file or URL.
   */
  public String getBase() {
    return base;
  }

  /**
   * Fetch a portion of source content.
   * @param start start index in source
   * @param len length of portion
   * @return Source content portion.
   */
  public String getString(int start, int len) {
    return new String(data(), start, len);
  }

  /**
   * Fetch a portion of source content associated with a token.
   * @param token Token descriptor.
   * @return Source content portion.
   */
  public String getString(long token) {
    var start = Token.descPosition(token);
    var len = Token.descLength(token);
    return new String(data(), start, len);
  }

  /**
   * Returns the source URL of this script Source.
   * Can be null if Source was created from a String or a char[].
   * @return URL source or null
   */
  public URL getURL() {
    return data.url();
  }

  /**
   * Get explicit source URL.
   * @return URL set via sourceURL directive
   */
  public String getExplicitURL() {
    return explicitURL;
  }

  /**
   * Set explicit source URL.
   * @param explicitURL URL set via sourceURL directive
   */
  public void setExplicitURL(String explicitURL) {
    this.explicitURL = explicitURL;
  }

  /**
   * Returns whether this source was submitted via 'eval' call or not.
   * @return true if this source represents code submitted via 'eval'
   */
  public boolean isEvalCode() {
    return data.isEvalCode();
  }

  /**
   * Find the beginning of the line containing position.
   * @param position Index to offending token.
   * @return Index of first character of line.
   */
  int findBOLN(int position) {
    var d = data();
    for (var i = position - 1; i > 0; i--) {
      var ch = d[i];
      if (ch == '\n' || ch == '\r') {
        return i + 1;
      }
    }
    return 0;
  }

  /**
   * Find the end of the line containing position.
   * @param position Index to offending token.
   * @return Index of last character of line.
   */
  int findEOLN(int position) {
    var d = data();
    var length = d.length;
    for (var i = position; i < length; i++) {
      var ch = d[i];
      if (ch == '\n' || ch == '\r') {
        return i - 1;
      }
    }
    return length - 1;
  }

  /**
   * Return line number of character position.
   * This method can be expensive for large sources as it iterates through all characters up to {@code position}.</p>
   * @param position Position of character in source content.
   * @return Line number.
   */
  public int getLine(int position) {
    var d = data();
    // Line count starts at 1.
    var line = 1;
    for (var i = 0; i < position; i++) {
      var ch = d[i];
      // Works for both \n and \r\n.
      if (ch == '\n') {
        line++;
      }
    }
    return line;
  }

  /**
   * Return column number of character position.
   * @param position Position of character in source content.
   * @return Column number.
   */
  public int getColumn(int position) {
    // TODO - column needs to account for tabs.
    return position - findBOLN(position);
  }

  /**
   * Return line text including character position.
   * @param position Position of character in source content.
   * @return Line text.
   */
  public String getSourceLine(int position) {
    // Find end of previous line.
    var first = findBOLN(position);
    // Find end of this line.
    var last = findEOLN(position);
    return new String(data(), first, last - first + 1);
  }

  /**
   * Get the content of this source as a char array.
   * Note that the underlying array is returned instead of a clone; modifying the char array will cause modification to the source; this should not be done.
   * While there is an apparent danger that we allow unfettered access to an underlying mutable array, the {@code Source} class is in a restricted {@code es.*} package and as such it is inaccessible by external actors in an environment with a security manager.
   * Returning a clone would be detrimental to performance.
   * @return content the content of this source as a char array
   */
  public char[] getContent() {
    return data();
  }

  /**
   * Get the length in chars for this source
   * @return length
   */
  public int getLength() {
    return data.length();
  }

  /**
   * Read all of the source until end of file. Return it as char array
   * @param reader reader opened to source stream
   * @return source as content
   * @throws IOException if source could not be read
   */
  public static char[] readFully(Reader reader) throws IOException {
    var arr = new char[BUF_SIZE];
    var sb = new StringBuilder();
    try {
      int numChars;
      while ((numChars = reader.read(arr, 0, arr.length)) > 0) {
        sb.append(arr, 0, numChars);
      }
    } finally {
      reader.close();
    }
    return sb.toString().toCharArray();
  }

  /**
   * Read all of the source until end of file.
   * Return it as char array
   * @param file source file
   * @return source as content
   * @throws IOException if source could not be read
   */
  public static char[] readFully(File file) throws IOException {
    if (!file.isFile()) {
      throw new IOException(file + " is not a file"); //TODO localize?
    }
    return byteToCharArray(Files.readAllBytes(file.toPath()));
  }

  /**
   * Read all of the source until end of file.
   * Return it as char array
   * @param file source file
   * @param cs Charset used to convert bytes to chars
   * @return source as content
   * @throws IOException if source could not be read
   */
  public static char[] readFully(File file, Charset cs) throws IOException {
    if (!file.isFile()) {
      throw new IOException(file + " is not a file"); //TODO localize?
    }
    var buf = Files.readAllBytes(file.toPath());
    return (cs != null) ? new String(buf, cs).toCharArray() : byteToCharArray(buf);
  }

  /**
   * Read all of the source until end of stream from the given URL. Return it as char array
   * @param url URL to read content from
   * @return source as content
   * @throws IOException if source could not be read
   */
  public static char[] readFully(URL url) throws IOException {
    return readFully(url.openStream());
  }

  /**
   * Read all of the source until end of file. Return it as char array
   * @param url URL to read content from
   * @param cs Charset used to convert bytes to chars
   * @return source as content
   * @throws IOException if source could not be read
   */
  public static char[] readFully(URL url, Charset cs) throws IOException {
    return readFully(url.openStream(), cs);
  }

  /**
   * Get a Base64-encoded SHA1 digest for this source.
   * @return a Base64-encoded SHA1 digest for this source
   */
  public String getDigest() {
    return new String(getDigestBytes(), StandardCharsets.US_ASCII);
  }

  byte[] getDigestBytes() {
    var ldigest = digest;
    if (ldigest == null) {
      var content = data();
      var bytes = new byte[content.length * 2];
      for (var i = 0; i < content.length; i++) {
        bytes[i * 2] = (byte) (content[i] & 0x00ff);
        bytes[i * 2 + 1] = (byte) ((content[i] & 0xff00) >> 8);
      }
      try {
        final MessageDigest md = MessageDigest.getInstance("SHA-1");
        if (name != null) {
          md.update(name.getBytes(StandardCharsets.UTF_8));
        }
        if (base != null) {
          md.update(base.getBytes(StandardCharsets.UTF_8));
        }
        if (getURL() != null) {
          md.update(getURL().toString().getBytes(StandardCharsets.UTF_8));
        }
        digest = ldigest = BASE64.encode(md.digest(bytes));
      } catch (NoSuchAlgorithmException e) {
        throw new RuntimeException(e);
      }
    }
    return ldigest;
  }

  /**
   * Returns the base directory or URL for the given URL. Used to implement __DIR__.
   * @param url a URL
   * @return base path or URL, or null if argument is not a hierarchical URL
   */
  public static String baseURL(URL url) {
    try {
      var uri = url.toURI();
      if (uri.getScheme().equals("file")) {
        var path = Paths.get(uri);
        var parent = path.getParent();
        return (parent != null) ? (parent + File.separator) : null;
      }
      if (uri.isOpaque() || uri.getPath() == null || uri.getPath().isEmpty()) {
        return null;
      }
      return uri.resolve("").toString();
    } catch (SecurityException | URISyntaxException | IOError e) {
      return null;
    }
  }

  static String dirName(File file, String DEFAULT_BASE_NAME) {
    var res = file.getParent();
    return (res != null) ? (res + File.separator) : DEFAULT_BASE_NAME;
  }

  // fake directory like name
  static String baseName(String name) {
    var idx = name.lastIndexOf('/');
    if (idx == -1) {
      idx = name.lastIndexOf('\\');
    }
    return (idx != -1) ? name.substring(0, idx + 1) : null;
  }

  static char[] readFully(InputStream is, Charset cs) throws IOException {
    return (cs != null) ? new String(readBytes(is), cs).toCharArray() : readFully(is);
  }

  public static char[] readFully(InputStream is) throws IOException {
    return byteToCharArray(readBytes(is));
  }

  static char[] byteToCharArray(byte[] bytes) {
    var cs = StandardCharsets.UTF_8;
    var start = 0;
    // BOM detection.
    if (bytes.length > 1 && bytes[0] == (byte) 0xFE && bytes[1] == (byte) 0xFF) {
      start = 2;
      cs = StandardCharsets.UTF_16BE;
    } else if (bytes.length > 1 && bytes[0] == (byte) 0xFF && bytes[1] == (byte) 0xFE) {
      if (bytes.length > 3 && bytes[2] == 0 && bytes[3] == 0) {
        start = 4;
        cs = Charset.forName("UTF-32LE");
      } else {
        start = 2;
        cs = StandardCharsets.UTF_16LE;
      }
    } else if (bytes.length > 2 && bytes[0] == (byte) 0xEF && bytes[1] == (byte) 0xBB && bytes[2] == (byte) 0xBF) {
      start = 3;
      cs = StandardCharsets.UTF_8;
    } else if (bytes.length > 3 && bytes[0] == 0 && bytes[1] == 0 && bytes[2] == (byte) 0xFE && bytes[3] == (byte) 0xFF) {
      start = 4;
      cs = Charset.forName("UTF-32BE");
    }
    return new String(bytes, start, bytes.length - start, cs).toCharArray();
  }

  static byte[] readBytes(InputStream is) throws IOException {
    var arr = new byte[BUF_SIZE];
    try {
      try (var buf = new ByteArrayOutputStream()) {
        int numBytes;
        while ((numBytes = is.read(arr, 0, arr.length)) > 0) {
          buf.write(arr, 0, numBytes);
        }
        return buf.toByteArray();
      }
    } finally {
      is.close();
    }
  }

  @Override
  public String toString() {
    return getName();
  }

  static URL getURLFromFile(File file) {
    try {
      return file.toURI().toURL();
    } catch (SecurityException | MalformedURLException ignored) {
      return null;
    }
  }

  static DebugLogger getLoggerStatic() {
    final Context context = Context.getContextTrustedOrNull();
    return context == null ? null : context.getLogger(Source.class);
  }

  @Override
  public DebugLogger initLogger(Context context) {
    return context.getLogger(this.getClass());
  }

  @Override
  public DebugLogger getLogger() {
    return initLogger(Context.getContextTrusted());
  }

  File dumpFile(File dirFile) {
    var u = getURL();
    var buf = new StringBuilder();
    // make it unique by prefixing current date & time
    buf.append(LocalDateTime.now().toString());
    buf.append('_');
    if (u != null) {
      // make it a safe file name
      buf.append(u.toString()
              .replace('/', '_')
              .replace('\\', '_'));
    } else {
      buf.append(getName());
    }
    return new File(dirFile, buf.toString());
  }

  void dump(String dir) {
    var dirFile = new File(dir);
    var file = dumpFile(dirFile);
    if (!dirFile.exists() && !dirFile.mkdirs()) {
      debug("Skipping source dump for " + name);
      return;
    }
    try (var fos = new FileOutputStream(file)) {
      var pw = new PrintWriter(fos);
      pw.print(data.toString());
      pw.flush();
    } catch (IOException ioExp) {
      debug("Skipping source dump for " + name + ": " + ECMAErrors.getMessage("io.error.cant.write", dir + " : " + ioExp.toString()));
    }
  }

}
