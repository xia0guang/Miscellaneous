/**
 * Created by wuxiaoguang on 1/8/15.
 */

import java.util.*;

public class Trie {

    public class Node {
        char c;
        String word;
        Node[] child;
        Node(char c){
            this.c = c;
            word = null;
            child = new Node[256];
        }
    }
    private Node root;

    public Trie() {
        root = new Node(' ');
    }

    public void insert(String key) {
        Node tmp = root;
        for(int i=0; i<key.length(); i++){
            char c = key.charAt(i);
            int index = (int)c;
            if(tmp.child[index] == null) {
                tmp.child[index] = new Node(c);
            }
            if(i == key.length()-1) {
                tmp.child[index].word = key;
            }
            tmp = tmp.child[index];
        }
    }

    public boolean search(String key) {
        if(key == null || key.length() == 0) return false;
        Node tmp = root;
        for (int i = 0; i < key.length(); i++) {
            char c = key.charAt(i);
            int index = (int)c;
            if(tmp.child[index] == null) return false;
            else {
                if(i == key.length()-1 && tmp.child[index].word.equals(key)) return true;
                tmp = tmp.child[index];
            }
        }
        return false;
    }

    public static void main(String args[]) {
        Trie trie = new Trie();
        trie.insert("abc");
        trie.insert("abd");
        trie.insert("bed");
        trie.insert("bac");
        System.out.println(trie.search("bac"));
        System.out.println(trie.search("bbb"));

    }
}
