package com.ray.personal.project.airbnb;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class BoggleGame {
    public List<String> boggle(Set<String> dict, char[][] board) {
        if(board.length == 0 || board[0].length == 0) return null;
        boolean[][] visited = new boolean[board.length][board[0].length];
        TreeNode node = buildTree(dict);
        List<String> result = new ArrayList<>();
        for (int i=0;i<board.length; i++) {
            for (int j=0; j<board[0].length; j++) {
                boggle(dict, board, visited, i, j, node, result);
            }
        }
        return result;
    }

    private void boggle(Set<String> dict, char[][] board, boolean[][] visited, int r, int c, TreeNode node, List<String> result) {
        if(r < 0 || r >= board.length || c < 0 || c >= board[0].length) {
            return;
        }

        char curChar = board[r][c];
        int index = curChar - 'A';

        if(node.nodes[index] == null) {
            return;
        }

        visited[r][c] = true;
        String word = node.nodes[index].word;
        if(word != null && dict.contains(word)) {
            result.add(word);
        }

        for(int i=r-1; i<=r+1; i++) {
            for(int j=c-1; j<=c+1; j++) {
                if (i != r || j != c) {
                    boggle(dict, board, visited, i, j, node.nodes[index], result);
                }
            }
        }
        visited[r][c] = false;
    }

    private TreeNode buildTree(Set<String> dict) {
        TreeNode root = new TreeNode();

        for(String s : dict) {
            TreeNode cur = root;
            char c = ' ';
            for(int i=0; i<s.length(); i++) {
                c = s.charAt(i);
                if(cur.nodes[c-'A'] == null) {
                    cur.nodes[c-'A'] = new TreeNode(c);
                }
                cur = cur.nodes[c-'A'];
            }
            if (c != ' ') {
                cur.word = s;
            }
        }
        return root;
    }

    public static class TreeNode {
        String word;
        char c;
        TreeNode[] nodes;

        TreeNode() {
            this(' ');
        }

        TreeNode(char c) {
            this.c = c;
            this.nodes = new TreeNode[26];
        }
    }
}
