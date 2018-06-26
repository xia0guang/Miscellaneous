package com.ray.personal.project.airbnb;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Pyramid {
    public boolean pyramidTransition(String bottom, List<String> allowed) {
        Map<String, List<Character>> allowedMap = new HashMap<>();
        for(int i=0; i<allowed.size(); i++) {
            String allowedBottom = allowed.get(i).substring(0,2);
            char allowedVertex = allowed.get(i).charAt(2);
            if(!allowedMap.containsKey(allowedBottom)) {
                allowedMap.put(allowedBottom, new ArrayList<>());
            }
            allowedMap.get(allowedBottom).add(allowedVertex);
        }
        System.out.println(allowedMap);

        return pyramidTransition(bottom, 0, "", allowedMap);
    }

    private boolean pyramidTransition(String bottom, int index, String upperLevel, Map<String, List<Character>> allowed) {
        if(bottom.length() == 0) return false;
        if(bottom.length() == 1) return true;

        System.out.println("Bottom: " + bottom);
        System.out.println("Index: " + index);

        String subBottom = bottom.substring(index, index + 2);
        if(!allowed.containsKey(subBottom)) return false;
        List<Character> possible = allowed.get(subBottom);

        System.out.println("possible: " + possible);

        StringBuilder sb = new StringBuilder(upperLevel);

        for(int i=0; i<possible.size(); i++) {
            sb.append(possible.get(i));
            System.out.println("StringBuilder: " + sb.toString());
            if(index < bottom.length()-2) {
                if(pyramidTransition(bottom, index + 1, sb.toString(), allowed)) {
                    return true;
                }
            } else {
                if(pyramidTransition(sb.toString(), 0, "", allowed)) {
                    return true;
                }
            }
            sb.deleteCharAt(sb.length()-1);
        }
        return false;
    }
}
