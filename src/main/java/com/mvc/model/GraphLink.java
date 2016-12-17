package com.mvc.model;

/**
 * Created by llc on 16/12/17.
 */
public class GraphLink {
    private int source;
    private int target;

    public GraphLink(int source, int target) {
        this.source = source;
        this.target = target;
    }

    public int getSource() {
        return source;
    }

    public void setSource(int source) {
        this.source = source;
    }

    public int getTarget() {
        return target;
    }

    public void setTarget(int target) {
        this.target = target;
    }
}
