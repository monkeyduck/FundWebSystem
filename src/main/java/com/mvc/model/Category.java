package com.mvc.model;

/**
 * Created by llc on 16/12/15.
 */
public class Category {
    private int categoryId;
    private String category;
    private int completeRate;
    // 0 ~ 25% 红色, 25%~50% 黄色, 50% ~ 75% 蓝色, 75% ~ 100% 绿色
    private String infoColor;

    public Category(int categoryId, String category, int completeRate) {
        this.categoryId = categoryId;
        this.category = category;
        this.completeRate = completeRate;
        if (completeRate <= 25) {
            infoColor = "danger";
        } else if (completeRate <= 50) {
            infoColor = "warning";
        } else if (completeRate <= 75) {
            infoColor = "info";
        } else {
            infoColor = "success";
        }
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getCompleteRate() {
        return completeRate;
    }

    public void setCompleteRate(int completeRate) {
        this.completeRate = completeRate;
    }

    public String getInfoColor() {
        return infoColor;
    }

    public void setInfoColor(String infoColor) {
        this.infoColor = infoColor;
    }
}
