package com.ray.personal.project;

public class LongestCommonPrefix {
    public String longestCommonPrefix(String[] strs) {
        if(strs == null || strs.length == 0) return "";
        StringBuilder sb = new StringBuilder();
        int len = 1;
        while(len <= strs[0].length()) {
            boolean end = false;
            char c = strs[0].charAt(len-1);
            for (int i = 1; i < strs.length; i++) {
                if(strs[i].charAt(len-1) != c) {
                    end = true;
                }
            }
            if(end) {
                break;
            }
            sb.append(c);
            len++;
        }
        return sb.toString();
    }

    public static void main(String[] args) {
        LongestCommonPrefix l = new LongestCommonPrefix();
        String[] ss = {"flower","flow","flight"};
        System.out.println(l.longestCommonPrefix(ss));
    }
}
