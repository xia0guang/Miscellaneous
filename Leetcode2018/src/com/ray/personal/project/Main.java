package com.ray.personal.project;


public class Main {

    public static void main(String[] args) {
        NestedIntList list = NestedIntList.fromString("[123,456,[788,799,833],[[]],10,[]]");
        System.out.println(new CollatzConjecture().findLongestSteps(10000));
    }
}
