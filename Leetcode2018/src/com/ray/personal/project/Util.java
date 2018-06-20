package com.ray.personal.project;

public class Util {
    public static void stringToArray(int[] array, String s) {
        String[] slist = s.split(" ");
        if(slist.length != array.length) {
            return;
        }
        for (int i = 0; i < array.length; i++) {
            try {
                array[i] = Integer.valueOf(slist[i]);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
    }

    public static void stringToMatrix(int[][] mat, String s) {
        String[] slist = s.split(",");
        if(slist.length != mat.length) {
            return;
        }
        for (int i = 0; i < slist.length; i++) {
            stringToArray(mat[i], slist[i]);
        }
    }
}
