import java.io.*;
import java.nio.*;
import java.nio.channels.*;
import java.nio.charset.*;
import java.util.*;

class ZalgoTest extends ZalgoParser {
	/* private static PrintStream out; */
	private static MappedByteBuffer out;

	public static final void main(String... args) throws Exception {
		int max = Integer.parseInt(args[0]);

		RandomAccessFile input = new RandomAccessFile("huge.svg", "rw");
		CharBuffer map = Charset.forName("ascii").decode(input.getChannel().map(FileChannel.MapMode.READ_ONLY, 0, input.length()));
		String str = map.toString();
		while (--max >= 0) {
			FileChannel chan = new RandomAccessFile(args[1], "rw").getChannel();
			out = chan.map(FileChannel.MapMode.READ_WRITE, 0, 10 << 20);
			new ZalgoTest().parse(new Scanner(str));
			out.force();
		}
		input.close();
	}

	private final void println(String str) {
		/* out.println(str); */
		out.put(str.getBytes());
		out.put((byte) '\n');
	}

	@Override
	protected void tag(String tagname) {
		println("Tag: " + tagname);
	}

	@Override
	protected void attribute(String key, String value) {
		println("Attr: " + key + " ==> " + value);
	}

	@Override
	protected void text(String text) {
		println("Text: " + text);
	}
}
