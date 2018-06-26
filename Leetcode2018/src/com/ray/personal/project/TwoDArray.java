package com.ray.personal.project;

import java.util.Iterator;
import java.util.List;
import java.util.function.Consumer;

public class TwoDArray <T> implements Iterator {
    List<List<T>> array;
    int rowId;
    int colId;
    int rowCount;

    public TwoDArray(List<List<T>> array) {
        this.array = array;
        rowId = 0;
        colId = 0;
        rowCount = array.size();
    }

    Iterator<T> iterator() {
        return this;
    }

    @Override
    public boolean hasNext() {
        if(array == null || array.isEmpty() ||
                rowId >= rowCount || array.get(rowId) == null || array.get(rowId).isEmpty() ||
                colId >= array.get(rowId).size()) return false;
        return true;
    }

    @Override
    public T next() {
        if(hasNext()) {
            T e = this.array.get(rowId).get(colId);
            while (rowId < rowCount && array.get(rowId) != null && !array.get(rowId).isEmpty()) {
                List<T> list = array.get(rowId);
                colId++;
                if(colId >= list.size()) {
                    colId = 0;
                    rowId++;
                }
            }

            return e;
        } else {
            return null;
        }
    }

    @Override
    public void remove() {

    }

    @Override
    public void forEachRemaining(Consumer action) {

    }
}
