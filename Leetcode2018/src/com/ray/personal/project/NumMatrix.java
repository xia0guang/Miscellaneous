package com.ray.personal.project;

public class NumMatrix {
    int[][] matrix;
    int[][] sumMatrix;

    public NumMatrix(int[][] matrix) {
        this.matrix = matrix;
        int size = this.matrix.length;
        this.sumMatrix = matrix;
        for(int i=0; i<size; i++) {
            for(int j=0; j<size; j++) {
                if(i==0 && j==0) {
                    sumMatrix[i][j] = this.matrix[i][j];
                } else if(i==0) {
                    sumMatrix[i][j] = sumMatrix[i][j-1] + this.matrix[i][j];
                } else if(j==0) {
                    sumMatrix[i][j] = sumMatrix[i-1][j] + this.matrix[i][j];
                } else {
                    sumMatrix[i][j] = sumMatrix[i-1][j] + sumMatrix[i][j-1] - sumMatrix[i-1][j-1] + this.matrix[i][j];
                }
            }
        }
    }

    public int sumRegion(int row1, int col1, int row2, int col2) {
        return this.sumMatrix[row2][col2] - (row1 == 0 ? 0 : this.sumMatrix[row1-1][col2]) - (col1 == 0 ? 0 : this.sumMatrix[row2][col1-1]) + (row1==0 || col1== 0 ? 0 : this.sumMatrix[row1-1][col1-1]);
    }

    private String matrixString(int[][] matrix) {
        StringBuilder sb = new StringBuilder();
        int height = matrix.length;
        if(height == 0) return "";
        int width = matrix[0].length;
        for (int i = 0; i < height; i++) {
            for(int j=0; j<width; j++) {
                sb.append(String.format("%5d",matrix[i][j]));
            }
            sb.append("\n");
        }
        return sb.toString();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Matrix: \n");
        sb.append(this.matrixString(this.matrix));
        sb.append("Sum Matrix: \n");
        sb.append(this.matrixString(this.sumMatrix));
        return sb.toString();
    }
}
