package com.mvc.model;

/**
 * Created by llc on 16/12/17.
 */
public class GraphNode {
    private int id;
    private String name;
    private String label;
    private int category;
    private int symbolSize;
    public static final int rootSize = 50;
    public static final int leafSize = 30;

    public GraphNode(int id, String name, int category, int size) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.symbolSize = size;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getCategory() {
        return category;
    }

    public void setCategory(int category) {
        this.category = category;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public int getSymbolSize() {
        return symbolSize;
    }

    public void setSymbolSize(int symbolSize) {
        this.symbolSize = symbolSize;
    }
}
