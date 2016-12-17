package com.mvc.model;

/**
 * Created by llc on 16/12/17.
 */
public class GraphNode {
    private int id;
    private String name;
    private String value;
    private int category;

    public GraphNode(int id, String name, String value, int category) {
        this.id = id;
        this.name = name;
        this.value = value;
        this.category = category;
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

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public int getCategory() {
        return category;
    }

    public void setCategory(int category) {
        this.category = category;
    }
}
