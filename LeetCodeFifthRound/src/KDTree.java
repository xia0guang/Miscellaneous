/**
 * Created by wuxiaoguang on 1/9/15.
 */
import java.util.*;

class KDTreeNode {
    int[] location = new int[2];
    KDTreeNode left, right;
    KDTreeNode(int x, int y) {
        location[0] = x;
        location[1] = y;
    }
}

public class KDTree {
    public static KDTreeNode constructTree(List<int[]> list, int deep) {
        if(list == null || list.size() == 0) return null;
        final int axis = deep % list.get(0).length;
        Collections.sort(list, new Comparator<int[]>() {
            @Override
            public int compare(int[] ints, int[] ints2) {
                return ints[axis] - ints2[axis];
            }
        });
        int mid = (list.size()-1)/2;
        KDTreeNode root = new KDTreeNode(list.get(mid)[0], list.get(mid)[1]);
        root.left = constructTree(list.subList(0, mid), deep+1);
        root.right = constructTree(list.subList(mid+1, list.size()), deep+1);
        return root;
    }

    public static List<KDTreeNode> searchRange(KDTreeNode root,int deep, int xLow, int xHigh, int yLow, int yHigh) {
        List<KDTreeNode> rst = new ArrayList<KDTreeNode>();
        if(root == null) return rst;
        int axis = deep % 2;
        if(axis == 0 && root.location[axis] >= xLow || axis == 1 && root.location[axis] >= yLow) rst.addAll(searchRange(root.left, deep+1, xLow, xHigh, yLow, yHigh));

        if(root.location[0] >= xLow && root.location[0] <= xHigh &&
           root.location[1] >= yLow && root.location[1] <= yHigh) rst.add(root);

        if(axis == 0 && root.location[axis] <= xHigh || axis == 1 && root.location[axis] <= yHigh) rst.addAll(searchRange(root.right, deep+1, xLow, xHigh, yLow, yHigh));
        return rst;
    }


    public static void main(String[] args) {
        List<int[]> list = new ArrayList<int[]>(
                Arrays.asList(new int[]{2, 3}, new int[]{5, 4}, new int[]{9, 6}, new int[]{4, 7}, new int[]{8, 1}, new int[]{7, 2}
                ));
        KDTreeNode root = KDTree.constructTree(list, 0);

        List<KDTreeNode> search = KDTree.searchRange(root, 0, 1,5,2,8);
        System.out.println(0);
    }
}
