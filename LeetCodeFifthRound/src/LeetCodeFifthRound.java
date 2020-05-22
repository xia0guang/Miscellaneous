/**
 * Created by wuxiaoguang on 12/30/14.
 */
import org.omg.CORBA.INTERNAL;

import java.util.*;

class DirectedGraphNode {
    int label;
    ArrayList<DirectedGraphNode> neighbors;
    DirectedGraphNode(int x) { label = x; neighbors = new ArrayList<DirectedGraphNode>(); }
};

class Point {
    int x;
    int y;
    Point() { x = 0; y = 0; }

    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }

    Point(int a, int b) { x = a; y = b; }
}

class GNode{
    String word;
    int path;
    List<GNode> neighbors;
    GNode(String s, int p) {
        word = s;
        path = p;
        neighbors = new ArrayList<GNode>();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof GNode)) return false;

        GNode gNode = (GNode) o;

        if (path != gNode.path) return false;
        if (neighbors != null ? !neighbors.equals(gNode.neighbors) : gNode.neighbors != null) return false;
        if (word != null ? !word.equals(gNode.word) : gNode.word != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = word != null ? word.hashCode() : 0;
        result = 31 * result + path;
        result = 31 * result + (neighbors != null ? neighbors.hashCode() : 0);
        return result;
    }
}

class TreeNode {
    int val;
    TreeNode left, right;
    TreeNode(int v) {
        this.val = v;
        left = null;
        right = null;
    }
}

class Tuple {
    int val;
    int arrIndex;
    int index;
    Tuple(int v, int a, int i) {
        this.val = v;
        this.arrIndex = a;
        this.index = i;
    }
}

class ListNode{
    public int val;
    ListNode(int v) {
        this.val = v;
    }
}

public class LeetCodeFifthRound {
    public int majorityElement(int[] num) {
        if(num == null || num.length < 2) return num[0];
        int a = num[0];
        int count = 1;
        for(int i=1; i<num.length; i++)
        {
            if(count == 0) {
                a = num[i];
                count = 1;
            } else {
                if(num[i] == a) count++;
                else count--;
            }
        }
        return a;
    }

    public String fractionToDecimal(int numerator, int denominator) {
        if(numerator == 0) return "0";
        if(denominator == 0) return "N/A";
        String sign = numerator*denominator < 0 ? "-" : "";
        long n = Math.abs((long)numerator), d = Math.abs((long)denominator);
        StringBuilder rst = new StringBuilder(Long.toString(n/d));
        n %= d;
        if(n == 0) return sign + rst.toString();
        else rst.append(".");
        HashMap<Long, Integer> map = new HashMap<Long, Integer>();
        while(n > 0) {
            if(map.containsKey(n)) {
                rst.insert(map.get(n), "(" );
                rst.append(")");
                break;
            }
            map.put(n, rst.length());
            n *= 10;
            rst.append(Long.toString(n/d));
            n %= d;
        }
        return sign + rst.toString();
    }

    public int findPair(String a, String b, List<String> words) {
        HashMap<String, List<Integer>> map = new HashMap<String, List<Integer>>();
        for(int i = 0; i<words.size(); i++) {
            String tmp = words.get(i);
            if(map.containsKey(tmp)) {
                map.get(tmp).add(i);
            } else {
                List<Integer> indexList = new ArrayList<Integer>();
                indexList.add(i);
                map.put(tmp, indexList);
            }
        }
        List<Integer> listA = map.get(a);
        List<Integer> listB = map.get(b);
        int i = 0, j = 0;
        int minLen = Integer.MAX_VALUE;
        while(i < listA.size() && j < listB.size()) {
            int ia = listA.get(i), ib = listB.get(j);
            minLen = Math.min(Math.abs(ia - ib), minLen);
            if(ia == ib) return 0;
            if(ia < ib) i++;
            else j++;
        }
        return minLen;
    }

    public List<Integer> occurOnce(int k) {
        List<Integer> rst = new ArrayList<Integer>();
        if(k == 1) {
            rst.add(1);
            return rst;
        }
        boolean[] visited = new boolean[k];
        helper(k, 0, 0, rst, visited);
        return rst;
    }

    private void helper(int k, int step, int curNum, List<Integer> rst, boolean[] visited) {
        if(step == k) {
           rst.add(curNum);
           return;
        }
        for(int i=0; i<visited.length; i++) {
            if(!visited[i]) {
                visited[i] = true;
                helper(k, step+1, curNum * 10 + i+1, rst, visited);
                visited[i] = false;
            }
        }
    }


    public List<Integer> mergeKSortedArray(List<int[]> arrays) {

        List<Integer> rst = new ArrayList<Integer>();
        if (arrays.size() == 0) return rst;
        PriorityQueue<Tuple> pq = new PriorityQueue<Tuple>(arrays.size(), new Comparator<Tuple>() {
            @Override
            public int compare(Tuple t1, Tuple t2) {
                return t1.val - t2.val;
            }
        });
        for (int i = 0; i < arrays.size(); i++) {
            int[] l = arrays.get(i);
            if (l.length > 0) {
                pq.offer(new Tuple(l[0], i, 0));
            }
        }

        while (!pq.isEmpty()) {
            Tuple tmp = pq.poll();
            rst.add(tmp.val);
            if (tmp.index < arrays.get(tmp.arrIndex).length - 1) {
                pq.offer(new Tuple(arrays.get(tmp.arrIndex)[tmp.index + 1], tmp.arrIndex, tmp.index + 1));
            }
        }
        return rst;
    }

    public int mostSumDigit(int k) {
        int[] sums = new int[55];
        for(int i=1; i<=k; i++) {
            sums[sum(i)]++;
        }
        int max = -1;
        for(int i=0; i<54; i++) {
            max = Math.max(max, sums[i]);
        }
        return max;
    }

    private int sum(int n) {
        int rst = 0;
        while(n > 0) {
            rst += n%10;
            n /= 10;
        }
        return rst;
    }

    public List<String> shortestSubstring(String s) {
        if(s == null || s.length() == 0) return Arrays.asList();
        for(int length=1; length<s.length(); length++) {
            HashMap<String, Integer> map = new HashMap<String, Integer>();
            for(int i=0; i+length <= s.length(); i++) {
                String sub = s.substring(i, i+length);
                if(map.containsKey(sub)) {
                    map.put(sub, map.get(sub)+1);
                } else {
                    map.put(sub, 1);
                }
            }
            List<String> rst = new ArrayList<String>();
            for(Map.Entry<String,Integer> entry : map.entrySet()) {
                if(entry.getValue() == 1) rst.add(entry.getKey());
            }
            if(rst.size() != 0) return rst;
        }
        return Arrays.asList(s);
    }

    public int twoPrimes(int k) {
        int start = 2, end = k-2;
        while(start < end) {
            if(isPrime(start) && isPrime(end)) return start;
            start++;
            end--;
        }
        return -1;
    }
    private boolean isPrime(int n) {
        if(n == 0 || n == 1) return false;
        for(int i=2; i< Math.sqrt((double)n); i++) {
            if(n % i == 0) return false;
        }
        return true;
    }

    public void radixSort(int[] arr, int digitcount) {
        for(int i=1; i<=digitcount; i++) {
            int[] bucket = new int[10];
            for(int j=0; j<arr.length; j++) {
                bucket[digit(arr[j], i)]++;
            }

            for(int j=1; j<10; j++) {
                bucket[j] += bucket[j-1];
            }
            int[] tmp = new int[arr.length];
            for(int j=arr.length-1; j >=0; j--) {
                int num = digit(arr[j], i);
                tmp[--bucket[num]] = arr[j];
            }
            arr = tmp;
        }
    }

    private int digit(int n, int kthDigit) {
        for(int i=1; i<kthDigit; i++) {
            n /= 10;
        }
        return n % 10;
    }


    public TreeNode findNode(TreeNode root, int value){
        if(root == null) return null;
        if(root.left == null && root.right == null) {
            if(root.val > value) return root;
            else return null;
        }

        if(root.val <= value) {
            return findNode(root.right, value);
        }
        else  {
            TreeNode left = findNode(root.left, value);
            if(left == null ) return root;
            else return left;
        }

    }

    public TreeNode buildTree(int[] preorder, int[] inorder) {
        return buildHelper(preorder, 0, preorder.length-1, inorder, 0, inorder.length-1);
    }

    private TreeNode buildHelper(int[] preorder, int preStart, int preEnd, int[] inorder, int inStart, int inEnd) {
        if(preStart > preEnd) return null;
        TreeNode root = new TreeNode(preorder[preStart]);
        int index = 0;
        for(int i=inStart; i<=inEnd; i++) {
            if(inorder[i] == preorder[preStart]) {
                index = i;
                break;
            }
        }
        int leftLen = index - inStart;
        root.left = buildHelper(preorder, preStart+1, preStart + leftLen, inorder, inStart, index - 1);
        root.right = buildHelper(preorder, preStart + leftLen + 1, preEnd, inorder, index+1, inEnd);
        return root;
    }

    public String longestPalindromicSubstring(String s) {
        if(s == null || s.length() == 0) return "";
        char[] str = s.toCharArray();
        String rst = "";
        for(int i=0; i<str.length; i++) {
            int left = i, right = i;
            while(left >=0 && right <str.length && str[left] == str[right]) {
                left--;
                right++;
            }
            if(rst.length() < right-left-1) rst = s.substring(left+1, right);
            if(i+1 < str.length && str[i] == str[i+1]) {
                left = i; right = i+1;
                while(left >=0 && right <str.length && str[left] == str[right]) {
                    left--;
                    right++;
                }
                if(rst.length() < right-left-1) rst = s.substring(left+1, right);
            }
        }
        return rst;
    }


    public static String longestPalindrome2(String s) {
        if (s == null)
            return null;

        if(s.length() <=1)
            return s;

        int maxLen = 0;
        String longestStr = null;

        int length = s.length();

        int[][] table = new int[length][length];

        //every single letter is palindrome
        for (int i = 0; i < length; i++) {
            table[i][i] = 1;
        }
        printTable(table);

        //e.g. bcba
        //two consecutive same letters are palindrome
        for (int i = 0; i <= length - 2; i++) {
            if (s.charAt(i) == s.charAt(i + 1)){
                table[i][i + 1] = 1;
                longestStr = s.substring(i, i + 2);
            }
        }
        printTable(table);
        //condition for calculate whole table
        for (int l = 3; l <= length; l++) {
            for (int i = 0; i <= length-l; i++) {
                int j = i + l - 1;
                if (s.charAt(i) == s.charAt(j)) {
                    table[i][j] = table[i + 1][j - 1];
                    if (table[i][j] == 1 && l > maxLen)
                        longestStr = s.substring(i, j + 1);
                } else {
                    table[i][j] = 0;
                }
                printTable(table);
            }
        }

        return longestStr;
    }
    public static void printTable(int[][] x){
        for(int [] y : x){
            for(int z: y){
                System.out.print(z + " ");
            }
            System.out.println();
        }
        System.out.println("------");
    }

    public List<List<String>> findLadders(String start, String end, Set<String> dict) {
        List<List<String>> rst = new ArrayList<List<String>>();
        if(start == null || start.length() == 0) return rst;
        Queue<String> q = new LinkedList<String>();
        q.offer(start);
        GNode root = new GNode(start, 1);
        HashMap<String, GNode> map = new HashMap<String, GNode>();
        map.put(start, root);
        boolean complete = false;
        while(!q.isEmpty()) {
            String tmp = q.poll();
            for(int i=0; i<tmp.length(); i++) {
                StringBuilder mut = new StringBuilder(tmp);
                for(char c = 'a'; c <= 'z'; c++) {
                    mut.setCharAt(i, c);
                    String mutt = mut.toString();
                    if(mutt.equals(tmp) || mutt.equals(start)) continue;
                    if(mutt.equals(end)) {
                        complete = true;
                        if(!map.containsKey(end)) {
                            GNode endNode = new GNode(end, map.get(tmp).path+1);
                            map.put(end, endNode);
                        }
                        if(map.get(end).path >= map.get(tmp).path+1) {
                            map.get(tmp).neighbors.add(map.get(mutt));
                        }
                        continue;
                    }
                    if(dict.contains(mutt)) {
                        if(!map.containsKey(mutt)) {
                            GNode interNode = new GNode(mutt, map.get(tmp).path+1);
                            map.put(mutt, interNode);
                            q.offer(mutt);
                            map.get(tmp).neighbors.add(map.get(mutt));
                        } else {
                            if(map.get(mutt).path > map.get(tmp).path+1) {
                                map.get(tmp).neighbors.add(map.get(mutt));
                            }
                        }
                    }
                }
            }
        }
        List<String> single = new ArrayList<String>();
        single.add(start);
        pathHelper(root, end, single, rst);
        return rst;
    }

    private void pathHelper(GNode root, String end, List<String> single, List<List<String>> rst) {
        if(root.word.equals(end)) {
            rst.add(new ArrayList(single));
            return;
        }
        if(root.neighbors != null) {
            for(GNode n : root.neighbors) {
                single.add(n.word);
                pathHelper(n, end, single, rst);
                single.remove(single.size()-1);
            }
        }
    }

    public int sumofK(int[] arr, int k) {
        if(arr.length == 0) return 0;
        PriorityQueue<Integer> pq = new PriorityQueue<Integer>(k, new Comparator<Integer>(){
            @Override
            public int compare(Integer i1, Integer i2) {
                return i2 - i1;
            }
        });

        for(int i=0; i<arr.length; i++) {

            pq.offer(arr[i]);
            if(pq.size() == k+1) pq.poll();
        }
        int sum = 0;
        while(!pq.isEmpty()) {
            sum += pq.poll();
        }
        return sum;
    }

    public boolean exist(char[][] board, String word) {
        boolean[][] visited = new boolean[board.length][board[0].length];
        for(int i=0; i<board.length; i++) {
            for(int j=0; j<board[i].length; j++) {
                if(searchHelper(board, i, j, word, 0, visited)) return true;
            }
        }
        return false;
    }

    private boolean searchHelper(char[][] board, int x, int y, String word, int index, boolean[][] visited) {
        if(x < 0 || x >= board.length || y < 0 || y >= board[x].length || visited[x][y]) return false;
        if(word.charAt(index) == board[x][y]) {
            if(index == word.length()-1) return true;
            visited[x][y] = true;
            if(searchHelper(board, x+1, y, word, index+1, visited) || searchHelper(board, x-1, y, word, index+1, visited) || searchHelper(board, x, y+1, word, index+1, visited) || searchHelper(board, x, y-1, word, index+1, visited)) return true;
            visited[x][y] = false;
            return false;
        } else return false;
    }

    public int maxProduct(int[] A) {
        if(0 == A.length) return Integer.MIN_VALUE;
        int max = A[0], curMax = A[0], curMin = A[0];
        for(int i=1; i<A.length; i++) {
            curMax = Math.max(A[i], Math.max(curMax * A[i], curMin * A[i]));
            curMin = Math.min(A[i], Math.min(curMax * A[i], curMin * A[i]));
            max = Math.max(max, curMax);
        }
        return max;
    }

    public int jump(int[] A) {
        int step = 0;
        int index = 0;
        while(index < A.length-1) {
            int newIndex = index;
            for(int i=1; i<= A[index]; i++) {
                if(index + i >= A.length-1) return step+1;
                if(index + i + A[index + i] > newIndex + A[newIndex]) newIndex = index + i;
            }
            if(index == newIndex) return -1;
            index = newIndex;
            step++;
        }
        return step;
    }

    public int trailingZeroes(int n) {
        int count = 0;
        for(long i=5; n/i>=1; i *=5) {
            count += n/i;
            System.out.println(n/i);
        }
        return count;
    }

    public int longestIncreasingSubsequence(int[] nums) {
        // write your code here
        if(nums.length < 2) return nums.length;
        int[] dp = new int[nums.length];
        dp[0] = 1;
        for(int i=1; i<nums.length; i++){
            dp[i] = 1;
            for(int j=0; j<i; j++) {
                if(nums[i] >= nums[j]) dp[i] = Math.max(dp[i], dp[j]+1);
            }
        }
        return dp[nums.length-1];
    }

    public ArrayList<DirectedGraphNode> topSort(ArrayList<DirectedGraphNode> graph) {
        final Map<DirectedGraphNode, Integer> map = new HashMap<DirectedGraphNode, Integer>();
        for(DirectedGraphNode node : graph) {
            if(!map.containsKey(node)) {map.put(node, 0);}
            for(DirectedGraphNode nb : node.neighbors){
                if(!map.containsKey(nb)) {
                    map.put(nb, 1);
                } else {
                    map.put(nb, map.get(nb)+1);
                }
            }
        }
        Collections.sort(graph, new Comparator<DirectedGraphNode>(){
            @Override
            public int compare(DirectedGraphNode a, DirectedGraphNode b) {
                return map.get(a) - map.get(b);
            }
        });

        return graph;
    }

    public TreeNode findBigger(TreeNode root, int val) {
        if (root == null) return null;
        TreeNode last = null;
        TreeNode cur = root;
        while (cur != null) {
            if (cur.val <= val) {
                if (last != null && last.val > val) return last;
                else {
                    last = cur;
                    cur = cur.right;
                }
            } else {
                if (last != null && last.val <= val) return cur;
                else {
                    last = cur;
                    cur = cur.left;
                }
            }
        }
        if(last.val > val) return last;
        return null;
    }

    public int atoi(String str) {
        if(str == null) return 0;
        str = str.trim();
        if(str.length() == 0) return 0;
        long rst = 0;
        int sign = 1;
        int i=0;
        if(str.charAt(i) == '+') i++;
        else if(str.charAt(i) == '-') {i++; sign = -1;}
        while(i<str.length() && str.charAt(i) == '0') i++;
        while(i < str.length()) {
            if(Character.isDigit(str.charAt(i))){
                rst = rst * 10 + (str.charAt(i++) - '0') * sign;
            } else break;
            if(rst > Integer.MAX_VALUE) {
                rst = Integer.MAX_VALUE;
                break;
            }
            if(rst < Integer.MIN_VALUE) {
                rst = Integer.MIN_VALUE;
                break;
            }
        }
        return (int)rst;
    }

    public static void main(String[] args) {
        LeetCodeFifthRound l = new LeetCodeFifthRound();

        System.out.println(l.atoi("9223372036854775809"));
    }
}
