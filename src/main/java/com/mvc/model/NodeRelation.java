package com.mvc.model;

/**
 * Created by llc on 16/11/22.
 */
public class NodeRelation {
    private int srcId;
    private int tarId;
    private int rank;

    public NodeRelation(int srcId, int tarId, int rank) {
        this.srcId = srcId;
        this.tarId = tarId;
        this.rank = rank;
    }

    public int getSrcId() {
        return srcId;
    }

    public void setSrcId(int srcId) {
        this.srcId = srcId;
    }

    public int getTarId() {
        return tarId;
    }

    public void setTarId(int tarId) {
        this.tarId = tarId;
    }

    public int getRank() {
        return rank;
    }

    public void setRank(int rank) {
        this.rank = rank;
    }
}
