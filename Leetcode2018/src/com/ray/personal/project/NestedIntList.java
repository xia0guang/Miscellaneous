package com.ray.personal.project;

import java.util.ArrayList;
import java.util.List;

/**
 * 实现一个mini parser, 输入是以下格式的string:"324" or"[123,456,[788,799,833],[[]],10,[]]"
 * 要求输出:324 or [123,456,[788,799,833],[[]],10,[]].
 * 也就是将字符串转换成对应的格式的数据.
 *
 * 输入一个数组的字符串, 要返回一个数组, 里面每一个元素是要么一个整数, 要么是一个数组.
 *
 * 但是注意数组可以多层嵌套.
 */

public class NestedIntList {
    enum Type {
        NUM,
        LIST
    }

    private int value;
    private List<NestedIntList> list;
    private Type type;

    public NestedIntList(String num) throws NumberFormatException {
        this.value = Integer.valueOf(num);
        this.type = Type.NUM;
    }

    public NestedIntList() {
        this.list = new ArrayList<>();
        this.type = Type.LIST;
    }

    public void add(NestedIntList list) {
        this.list.add(list);
    }

    @Override
    public String toString() {
        if(this.type == Type.NUM) {
            return value + "";
        } else {
            StringBuilder sb = new StringBuilder();
            sb.append("[");
            for(int i=0; i<list.size(); i++) {
                sb.append(list.get(i).toString());
                if(i != list.size()-1) {
                    sb.append(",");
                }
            }
            sb.append("]");
            return sb.toString();
        }
    }

    public static NestedIntList fromString(String s) {
        if(s == null || s.isEmpty()) return new NestedIntList();
        if(!s.startsWith("[")) {
            return new NestedIntList(s);
        }
        NestedIntList result = new NestedIntList();
        if(s.length() == 2) {
            return result;
        }

        int i = 1;
        StringBuilder sb = new StringBuilder();
        int leftBracketCount = 0;
        while(i < s.length()) {
            char c = s.charAt(i);
            if((c == ',' && leftBracketCount == 0) || i == s.length() - 1) {
                result.add(fromString(sb.toString()));
                sb = new StringBuilder();
            } else {
                sb.append(c);
                if(c == '[') {
                    leftBracketCount += 1;
                } else if(c == ']') {
                    leftBracketCount -= 1;
                }
            }
            i++;
        }
        return result;
    }
}
