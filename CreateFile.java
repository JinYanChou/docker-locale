import java.io.*;

public class CreateFile {
  public static void main(String[] args) throws Exception {
    String filename = "測試.txt";
    File file = new File(filename);
    System.out.println(filename);
    FileOutputStream fos = new FileOutputStream(file);
    byte[] strToByte = "中文".getBytes();
    fos.write(strToByte);
    fos.close();

    System.err.println(new File("./20200420090711000120_區部業績明細_202004_1090420.csv").exists());
  }
}