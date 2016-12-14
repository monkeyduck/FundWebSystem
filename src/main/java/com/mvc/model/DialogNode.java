package com.mvc.model;

/**
 * Created by llc on 16/10/25.
 */
public class DialogNode {
    private int nodeId;
    private int topicId;
    private String topic;
    private boolean isLeaf;
    private boolean hasConnect;
    private String content;

    public DialogNode(int nodeId, String topic, String content, boolean hasConnect) {
        this.nodeId = nodeId;
        this.topic = topic;
        this.content = content;
        this.hasConnect = hasConnect;
    }

    public DialogNode(int nodeId, String topic, String content){
        this.nodeId = nodeId;
        this.topic = topic;
        this.content = content;
    }

    public int getNodeId() {
        return nodeId;
    }

    public void setNodeId(int nodeId) {
        this.nodeId = nodeId;
    }

    public int getTopicId() {
        return topicId;
    }

    public void setTopicId(int topicId) {
        this.topicId = topicId;
    }

    public String getTopic() {
        return topic;
    }

    public void setTopic(String topic) {
        this.topic = topic;
    }

    public boolean isLeaf() {
        return isLeaf;
    }

    public void setLeaf(boolean leaf) {
        isLeaf = leaf;
    }

    public boolean isHasConnect() {
        return hasConnect;
    }

    public void setHasConnect(boolean hasConnect) {
        this.hasConnect = hasConnect;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
