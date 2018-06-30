package com.ray.personal.project;

import java.util.LinkedList;
import java.util.Queue;

public class Codec {

    // Encodes a tree to a single string.
    public String serialize(TreeNode root) {
        if(root == null) return "[null]";
        StringBuilder sb = new StringBuilder();
        sb.append("[");

        Queue<TreeNode> q = new LinkedList<>();
        q.offer(root);
        while(!q.isEmpty()) {
            int size = q.size();
            for (int i = 0; i < size; i++) {
                TreeNode cur = q.poll();
                if(cur == null) {
                    sb.append(", null");
                    continue;
                }
                if(sb.length() != 1) {
                    sb.append(" ,");
                }
                sb.append(cur.val);
                q.offer(cur.left);
                q.offer(cur.right);
            }
        }

        sb.append("]");
        return sb.toString();
    }

    // Decodes your encoded data to tree.
    public TreeNode deserialize(String data) {
        if(data == null || data.isEmpty()) return null;
        if(data.startsWith("[")) {
            data = data.substring(1,data.length()-1);
        }
        if(data.isEmpty()) return null;

        String[] nodeStrArr = data.split(",");
        Queue<TreeNode> q = new LinkedList<>();
        if(nodeStrArr[0].equals("null")) {
            return null;
        }
        TreeNode root = new TreeNode(Integer.valueOf(nodeStrArr[0].trim()));
        TreeNode cur = root;
        int i= 1;
        while(i < nodeStrArr.length) {
            if(cur != null) {
                String nodeStr = nodeStrArr[i].trim();
                if(!nodeStr.equals("null")) {
                    cur.left = new TreeNode(Integer.valueOf(nodeStr));
                    q.offer(cur.left);
                }
                i++;
                nodeStr = nodeStrArr[i].trim();
                if(!nodeStr.equals("null")) {
                    cur.right= new TreeNode(Integer.valueOf(nodeStr));
                    q.offer(cur.right);
                }
                i++;
                cur = null;
            } else {
                cur = q.poll();
            }
        }

        return root;
    }

    public static void main(String[] args) {
        Codec c = new Codec();
        TreeNode root = c.deserialize("[1,2,3,null,null,4,5]");
        System.out.println(c.serialize(root));
    }
}
