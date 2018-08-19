package com.ray.personal.project.airbnb;

import java.util.Iterator;
import java.util.List;
import java.util.function.Consumer;

public class TwoDArray <T> implements Iterator {
    List<List<T>> array;
    Iterator<List<T>> rowIter;
    Iterator<T> colIter;

    public TwoDArray(List<List<T>> array) {
        this.array = array;
        rowIter = array.iterator();
        colIter = null;
    }

    Iterator<T> iterator() {
        return this;
    }

    @Override
    public boolean hasNext() {
        while((this.colIter == null || !this.colIter.hasNext()) && rowIter.hasNext()) {
            this.colIter = rowIter.next().iterator();
        }
        return this.colIter != null && this.colIter.hasNext();
    }

    @Override
    public T next() {
        return this.colIter.next();
    }

    @Override
    public void remove() {
        while((this.colIter == null || !this.colIter.hasNext()) && rowIter.hasNext()) {
            this.colIter = rowIter.next().iterator();
        }
        if (this.colIter != null) {
            this.colIter.remove();
        }
    }

    @Override
    public void forEachRemaining(Consumer action) {

    }
}
