package com.ray.personal.project;


import com.ray.personal.project.airbnb.CollatzConjecture;
import com.ray.personal.project.airbnb.NestedIntList;

public class Main {

    public static void main(String[] args) {
        NestedIntList list = NestedIntList.fromString("[123,456,[788,799,833],[[]],10,[]]");
        System.out.println(new CollatzConjecture().findLongestSteps(10000));
    }
}
