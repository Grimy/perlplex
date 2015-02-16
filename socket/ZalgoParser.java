import java.util.Scanner;
import java.util.regex.Pattern;

public abstract class ZalgoParser {
	private static final Pattern ATTR = Pattern.compile("\\s*+=\\s*+(['\"])(.*?)\\1");
	private static final Pattern TEXT = Pattern.compile("(?:[^<]|<!.*?>)*+");
	private static final Pattern NAME = Pattern.compile("<?\\??\\s*(/?[\\w:\\-]+|/|>)");

	protected abstract void tag(String tagname);
	protected abstract void attribute(String key, String value);
	protected abstract void text(String text);
	
	public final void parse(Scanner scanner) {
		String currentTag = null;
		for (String key = ">";; key = scanner.skip(NAME).match().group(1)) {
			if (key.equals(">")) {
				text(scanner.skip(TEXT).match().group());
				if (!scanner.hasNext()) {
					return;
				}
				tag(currentTag = scanner.skip(NAME).match().group(1));
			} else if (key.equals("/")) {
				tag("/" + currentTag);
			} else {
				attribute(key, scanner.skip(ATTR).match().group(2));
			}
		}
	}
}
