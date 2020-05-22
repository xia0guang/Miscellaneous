/**
 * Created by wuxiaoguang on 1/8/15.
 */

import java.util.*;

interface File {
    boolean isDirectory = false;
    File[] listFiles();
}

public class Directory implements File{

    private List<File> allFiles;

    @Override
    public File[] listFiles() {
        //TODO
        return new File[0];
    }

    public static List<File> listAllFiles(File input) {
        List<File> rst = new ArrayList<File>();
        if(input.isDirectory) {
            for(File f : input.listFiles()) {
                if(f.isDirectory == false) rst.add(f);
                else {
                    rst.addAll(listAllFiles(f));
                }
            }
        }
        return rst;
    }
}
