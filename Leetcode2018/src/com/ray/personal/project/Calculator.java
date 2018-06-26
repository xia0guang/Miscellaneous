package com.ray.personal.project;

import java.util.Stack;

public class Calculator {
    public int calculate(String s) {
        /*
        int len;
        if(s==null || (len = s.length())==0) return 0;
        Stack<Integer> stack = new Stack<Integer>();
        int num = 0;
        char LastOperator = '+';
        boolean lastCharIsSign = false;
        int sign = 1;
        for(int i=0;i<len;i++){
            if(s.charAt(i) == ' ') continue;

            if(Character.isDigit(s.charAt(i))){
                num = num*10+s.charAt(i)-'0';
            }
            if(!Character.isDigit(s.charAt(i)) || i==len-1) {
                if(lastCharIsSign) {
                    if(s.charAt(i) == '-') {
                         sign = -1;
                         lastCharIsSign = false;
                    }
                    continue;
                }
                if(LastOperator=='-'){
                    stack.push(-num * sign);
                }
                if(LastOperator=='+'){
                    stack.push(num * sign);
                }
                if(LastOperator=='*'){
                    stack.push(stack.pop()*num * sign);
                }
                if(LastOperator=='/'){
                    stack.push(stack.pop()/(num * sign));
                }
                if(i != len-1) {
                    LastOperator = s.charAt(i);
                }
                num = 0;
                sign = 1;
            }
            lastCharIsSign = !Character.isDigit(s.charAt(i));
            System.out.println(LastOperator);
        }

        int re = 0;
        for(int i:stack){
            re += i;
        }
        return re;
        */

        //Non negative version

        s = s.trim();
        int len = s.length();
        if(s==null || len ==0) return 0;
        Stack<Integer> stack = new Stack<Integer>();
        int num = 0;
        char LastOperator = '+';
        for(int i=0;i<len;i++){
            if(s.charAt(i) == ' ') continue;

            if(Character.isDigit(s.charAt(i))){
                num = num*10+s.charAt(i)-'0';
            }
            if(!Character.isDigit(s.charAt(i)) || i==len-1) {
                if(LastOperator=='-'){
                    stack.push(-num);
                }
                if(LastOperator=='+'){
                    stack.push(num);
                }
                if(LastOperator=='*'){
                    stack.push(stack.pop()*num);
                }
                if(LastOperator=='/'){
                    stack.push(stack.pop()/(num));
                }
                if(i != len-1) {
                    LastOperator = s.charAt(i);
                }
                num = 0;
            }
            System.out.println(LastOperator);
        }

        int re = 0;
        for(int i:stack){
            re += i;
        }
        return re;

    }

    public static void main(String[] args) {
        System.out.println(new Calculator().calculate("(1+(4+5+2)-3)+(6+8)"));
    }
}
