package com.ray.personal.project;


import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class Main {

    public static void main(String[] args) {
        char boggle[][] = {{'G','I','Z'},
            {'U','E','K'},
            {'Q','S','E'}};
        Set<String> dict = new HashSet<>(Arrays.asList("GEEKS", "FOR", "QUIZ", "GO"));
        BoggleGame gb = new BoggleGame();
        System.out.println(gb.boggle(dict, boggle));
    }
}
