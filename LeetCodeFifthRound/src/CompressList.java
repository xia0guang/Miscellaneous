import java.util.*;

public class CompressList<K, V>{
    private List<Map<K, V>> list;
    private Map<K, Node> map;
    private class Node{
        V v;
        BitSet indices;
        Node next;
        Node(V v, int size, int i){
            this.indices = new BitSet(size);
            indices.set(i, true);
            this.v = v;
            this.next = null;
        }
    }
/*
    private Map<K, V> mapSame;
    private Map<Integer, Map<K,V>> mapOther;*/

    CompressList(List<Map<K,V>> list) {
        this.list = list;
        map = new HashMap<K, Node>();
        for(int i=0; i<list.size(); i++) {
            for(Map.Entry<K, V> entry : list.get(i).entrySet()) {
                K k = entry.getKey();
                V v = entry.getValue();
                if(!map.containsKey(k)){
                    Node n = new Node(v, list.size(), i);
                    map.put(k, n);
                } else {
                    Node tmp = map.get(k);
                    if(tmp.v.equals(v)) tmp.indices.set(i,true);
                    else {
                        while(tmp.next != null) {
                            if(tmp.next.v.equals(v)) {
                                tmp.next.indices.set(i,true);
                                break;
                            } else {
                                tmp = tmp.next;
                            }
                        }
                        if(tmp.next == null) {
                            tmp.next = new Node(v, list.size(), i);
                        }
                    }
                }

            }
        }
    }

    public V get(int indexList, K k) {
        if(!map.containsKey(k)) return null;
        else {
            Node tmp = map.get(k);
            while(tmp != null) {
                if(tmp.indices.get(indexList)) return tmp.v;
                else tmp = tmp.next;
            }
            return null;
        }
    }

/*    CompressList(List<Map<K,V>> list) {
        this.list = list;
        mapSame = new HashMap<K, V>();
        mapOther = new HashMap<Integer, Map<K, V>>();
        for(Map.Entry<K, V> entry : this.list.get(0).entrySet() ){
            int i=1;
            for(; i<list.size(); i++) {
                if(!list.get(i).containsKey(entry.getKey()) || !entry.getValue().equals(list.get(i).get(entry.getKey()))) break;
            }
            if(i == list.size()) {
                mapSame.put(entry.getKey(), entry.getValue());
                for(int j=1; j<list.size(); j++) {
                    list.get(j).remove(entry.getKey());
                }
            }

        }
        for(Map.Entry<K, V> entry : mapSame.entrySet()){
            list.get(0).remove(entry.getKey());
        }
        for(int i=0; i<list.size(); i++){
            mapOther.put(i, list.get(i));
        }

    }

    public V get(int indexList, K k) {
        if(mapSame.containsKey(k)) return mapSame.get(k);
        else return mapOther.get(indexList).get(k);
    }*/
}