import java.nio.*;
import java.io.*;
import java.nio.channels.*;
import java.net.*;
import java.util.*;
import java.util.regex.*;

class Main {
	private static final float[] nans = new float[65536];
	
	private static void testTagging() {
		for (int i = 0; i < 65536; ++i) {
			nans[i] = Float.intBitsToFloat(0xFF80000 | i);
		}
		for (int i = 0; i < 65536; ++i) {
			assert (Float.floatToRawIntBits(nans[i]) & ~0xFF80000) == i;
		}
	}

	public static void main(String... args) throws Exception {
		testTagging();
		testXML(new Scanner(System.in));
	}

	private static void tag(String tagname) {
		System.out.println("Tag: " + tagname);
	}

	private static void attribute(String key, String value) {
		System.out.println("Attr: " + key + " ==> " + value);
	}

	private static void text(String text) {
		System.out.println("Text: " + text);
	}

	private static final Pattern ATTR_VALUE = Pattern.compile("\\s*=\\s*(['\"])(.*?)\\1");
	private static final Pattern TEXT = Pattern.compile("(?:[^<]|<!--.*?-->)*");

	private static void testXML(Scanner scanner) {
		scanner.useDelimiter("<\\??|\\s*(?:[\\s=?]|(?<=>)|(?=>))");
		while (scanner.hasNext()) {
			text(scanner.skip(TEXT).match().group().trim());
			tag(scanner.next());
			for (String key = scanner.next(); !key.equals(">"); key = scanner.next()) {
				if (key.equals("/")) {
					continue;
				}
				attribute(key, scanner.skip(ATTR_VALUE).match().group(2));
			}
		}
	}
}
