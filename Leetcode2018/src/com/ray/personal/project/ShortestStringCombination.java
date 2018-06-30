package com.ray.personal.project;

/**
 *第二道是给字符串s1,s2,找最短字符串同时包含s1,s2.(比如"bbbcc","ccd",应该返回"bbbccd")
 */
public class ShortestStringCombination {
   public String combine(String str1, String str2) {
       if (str1.isEmpty() || str2.isEmpty()) {
           return str1.isEmpty() ? str2 : str1;
       }
       if (str1.contains(str2)) {
           return str1;
       }
       if (str2.contains(str1)) {
           return str2;
       }

       String com1 = combineHelper(new StringBuilder(str1).reverse().toString(), str2);
       String com2 = combineHelper(new StringBuilder(str2).reverse().toString(), str1);
       return com1.length() <= com2.length() ? com1 : com2;
   }
   private String combineHelper(String str1, String str2) {
        StringBuilder result = new StringBuilder();
        StringBuilder predix = new StringBuilder();
        int index = 0;
        while(index < str1.length() && index < str2.length()) {
            char c1 = str1.charAt(index);
            char c2 = str2.charAt(index);
            if(c1 != c2) {
                break;
            }
            predix.append(c1);
            index++;
        }
        result.append(str1.substring(index, str1.length()));
        result = result.reverse();
        result.append(predix);
        result.append(str2.substring(index, str2.length()));

        return  result.toString();
   }

    public static void main(String[] args) {
        ShortestStringCombination s = new ShortestStringCombination();
        System.out.println(s.combine("bbaad", "aad"));
    }
}
