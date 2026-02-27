import java.io.*;
import java.util.regex.*;

public class run {
    static Pattern pattern = Pattern.compile("c?ei");

    static boolean isValid(String s) {
        Matcher m = pattern.matcher(s);
        while (m.find()) {
            if (!m.group().startsWith("c")) {
                return false;
            }
        }
        return true;
    }

    public static void main(String[] args) throws Exception {
        BufferedReader reader = new BufferedReader(new FileReader(args[0]));
        String line;
        while ((line = reader.readLine()) != null) {
            if (!isValid(line)) {
                System.out.println(line);
            }
        }
        reader.close();
    }
}
