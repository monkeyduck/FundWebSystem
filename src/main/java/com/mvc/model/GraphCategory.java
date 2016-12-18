package com.mvc.model;

/**
 * Created by llc on 16/12/17.
 */
public class GraphCategory {
    private String name;
    private String symbol;

    public GraphCategory(String name) {
        this.name = name;
        this.symbol = "circle"; // 默认为圆形
    }

    public GraphCategory(String name, String symbol) {
        this.name = name;
        this.symbol = symbol;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSymbol() {
        return symbol;
    }

    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }
}
