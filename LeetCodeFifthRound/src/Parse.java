import java.util.Stack;

/**
 * Created by wuxiaoguang on 4/15/15.
 */


public class Parse{
    public static class TreeNode{
        char val;
        TreeNode left, right;
        TreeNode(char val) {
            this.val = val;
            left = null;
            right = null;
        }
    }

    public static TreeNode parse(String str) {
        if(str == null || str.trim().length() == 0) return null;
        char[] strArr = str.toCharArray();
        TreeNode root = new TreeNode(strArr[0]);
        Stack<TreeNode> stack = new Stack<TreeNode>();
        TreeNode cur = root;
        for(int i=1; i<strArr.length; i++) {
            if(strArr[i] == '?') {
                if(i+1 < strArr.length && Character.isLetter(strArr[i+1]) ) {
                    if(cur != null) cur.left = new TreeNode(strArr[i+1]);
                    i++;

                }
                stack.push(cur);
                cur = cur.left;
            } else if(strArr[i] == ':') {
                if(!stack.isEmpty()) cur = stack.pop();
                else {
                    cur = null;
                    break;
                }
                if(i+1 < strArr.length && Character.isLetter(strArr[i+1]) ) {
                    cur.right = new TreeNode(strArr[i+1]);
                    cur = cur.right;
                    i++;
                }

            }
        }
        return root;
    }

    public static void main(String[] args) {
        TreeNode root = parse("a?:c?");
        System.out.println();
    }
}
