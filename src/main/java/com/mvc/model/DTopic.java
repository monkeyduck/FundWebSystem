package com.mvc.model;

import net.sf.json.JSONObject;

/**
 * Created by llc on 16/11/16.
 */
public class DTopic implements Comparable<DTopic> {
    private int id;
    private String key;
    private String content;
    private int catId;
    private String category;
    private int complete;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getCatId() {
        return catId;
    }

    public void setCatId(int catId) {
        this.catId = catId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getComplete() {
        return complete;
    }

    public void setComplete(int complete) {
        this.complete = complete;
    }

    @Override
    public int compareTo(DTopic o) {
        int complete = o.getComplete();
        return Integer.compare(this.complete, complete);
    }

    @Override
    public String toString() {
        return JSONObject.fromObject(this).toString();
    }
}
