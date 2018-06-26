package com.ray.personal.project;

import java.util.*;

/**
 * Given a list of unique words, find all pairs of distinct indices (i, j) in the given list, so that the concatenation of the two words, i.e. words[i] + words[j] is a palindrome.
 *
 * Example 1:
 * Given words = ["bat", "tab", "cat"]
 * Return [[0, 1], [1, 0]]
 * The palindromes are ["battab", "tabbat"]
 * Example 2:
 * Given words = ["abcd", "dcba", "lls", "s", "sssll"]
 * Return [[0, 1], [1, 0], [3, 2], [2, 4]]
 * The palindromes are ["dcbaabcd", "abcddcba", "slls", "llssssll"]
 */

public class PalindromePair {
    public List<List<Integer>> palindromePairs(String[] words) {
        if(words == null || words.length < 2) return null;
        Map<String, Integer> wordsMap = new HashMap<>();
        for(int i=0; i< words.length; i++) {
            wordsMap.put(words[i], i);
        }

        List<List<Integer>> rst = new ArrayList<>();

        for (int i = 0; i < words.length; i++) {
            //System.out.println(words[i]);
            for (int j = 0; j <= words[i].length(); j++) {
                String sub1 = words[i].substring(0,j);
                String sub2 = words[i].substring(j);

                //System.out.println("sub1: " + sub1);

                if(isPal(sub1)) {
                    String sub2Reversed = new StringBuilder(sub2).reverse().toString();
                    if(wordsMap.get(sub2Reversed) != null &&  wordsMap.get(sub2Reversed) != i) {
                        rst.add(Arrays.asList(wordsMap.get(sub2Reversed), i));
                    }
                }

                //System.out.println("sub2: " + sub2);

                if(isPal(sub2)) {
                    String sub1Reversed = new StringBuilder(sub1).reverse().toString();
                    if(wordsMap.get(sub1Reversed) != null && wordsMap.get(sub1Reversed) != i && sub2.length() != 0) {
                        rst.add(Arrays.asList(i, wordsMap.get(sub1Reversed)));
                    }
                }
            }
        }

        return  rst;

    }

    private boolean isPal(String s) {
        if(s == null || s.isEmpty()) return  true;
        int i=0, j=s.length()-1;
        while(i<j) {
            if(s.charAt(i) != s.charAt(j)) return false;
            i++;
            j--;
        }
        return true;
    }

    public static void main(String[] args) {
        String[] ss = {"abcd", "dcba", "lls", "s", "sssll"};
        System.out.println(new PalindromePair().palindromePairs(ss));
    }
}
