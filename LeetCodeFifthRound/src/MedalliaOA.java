/**
 * Created by wuxiaoguang on 12/29/14.
 */

import java.util.*;
public class MedalliaOA {
    public static Iterator<String> flatten(final Iterator<Iterator<String>> iters) {
        return new Iterator<String>(){
            private Iterator<String> curIter=null;
            private String nextItem=getNextItem();
            private String getNextItem(){
                if(iters==null&&curIter==null) {
                    throw new NullPointerException();
                }

                while((iters!=null&&iters.hasNext())||(curIter!=null&&curIter.hasNext())){
                    if((curIter==null||!curIter.hasNext())){
                        curIter=iters.next();
                    }
                    if(curIter == null) continue;

                    if(curIter.hasNext()){
                        String result=curIter.next();
                        if(result!=null){
                            return result;
                        }
                    }
                }
                return null;
            }
            public boolean hasNext()
            {
                return nextItem!=null;
            }

            public String next() {
                if (!hasNext())
                {
                    throw new NullPointerException();
                }
                String lastItem = nextItem;
                nextItem = getNextItem();
                return lastItem;
            }
            public void remove()
            {
                throw new UnsupportedOperationException();
            }
        };
    }

    public static void main(String args[]) throws Exception {
        List<Iterator<String>> lists = new ArrayList<Iterator<String>>();
        lists.add(Arrays.asList("a", "b", "c").iterator());
        lists.add(null);
        lists.add(Arrays.<String>asList().iterator());
        lists.add(Arrays.asList("d", "e").iterator());
        lists.add(Arrays.<String>asList().iterator());

        Iterator<Iterator<String>> iters = lists.iterator();
        Iterator<String> flattened = flatten(iters);
        while (flattened.hasNext()) {
            System.out.println(flattened.next());
        }
    }
}
