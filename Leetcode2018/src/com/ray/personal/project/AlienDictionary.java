package com.ray.personal.project;

import java.util.*;

/**
 * Problem Description:
 *
 * There is a new alien language which uses the latin alphabet. However, the order among letters are unknown to you. You receive a list of words from the dictionary, wherewords are sorted lexicographically by the rules of this new language. Derive the order of letters in this language.
 *
 * For example,
 * Given the following words in dictionary,
 *
 * [
 *   "wrt",
 *   "wrf",
 *   "er",
 *   "ett",
 *   "rftt"
 * ]
 * The correct order is: "wertf".
 *
 * Note:
 *
 * You may assume all letters are in lowercase.
 * If the order is invalid, return an empty string.
 * There may be multiple valid order of letters, return any one of them is fine.
 */

public class AlienDictionary {
    public String alienOrder(List<String> dict) {
        if(dict.size() == 0) return "";
        if(dict.size() == 1) return dict.get(0);

        Map<Character, Set<Character>> graph = graph(dict);
        StringBuilder sb = new StringBuilder();

        while(graph.size() > 0) {
            Map<Character, Set<Character>> toRemove = new HashMap<>(graph);
            for(Map.Entry<Character, Set<Character>> pair : graph.entrySet()) {
                for(Character c : pair.getValue()) {
                    toRemove.remove(c);
                }
            }
            for(Map.Entry<Character, Set<Character>> pair : toRemove.entrySet()) {
                sb.append(pair.getKey());
                graph.remove(pair.getKey());
            }
        }
        return sb.toString();
    }

    private Map<Character, Set<Character>> graph(List<String> dict) {//dict has to have size more than 2
        Map<Character, Set<Character>> result = new HashMap<>();
        for(int i=1; i<dict.size(); i++) {
            String word1 = dict.get(i-1);
            String word2 = dict.get(i);
            int j=0, len1 = word1.length(), len2 = word2.length();
            boolean foundDiffer = false;
            while(j<len1 || j <len2) {
                if(j<len1 && !result.containsKey(word1.charAt(j))) {
                    result.put(word1.charAt(j), new HashSet<>());
                }
                if(j<len2 &&!result.containsKey(word2.charAt(j))) {
                    result.put(word2.charAt(j), new HashSet<>());
                }

                if(j<len1 && j<len2 && word1.charAt(j) != word2.charAt(j) && !foundDiffer) {
                    result.get(word1.charAt(j)).add(word2.charAt(j));
                    foundDiffer = true;
                }
                j++;
            }
        }
        return result;
    }
}
