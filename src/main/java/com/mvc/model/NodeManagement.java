package com.mvc.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by llc on 16/11/21.
 */
public class NodeManagement {

    public static List<Integer> getCandidates(int nodeId){
        List<Integer> candList = new ArrayList<>();
        int n = 10;
        int totalNum = 22467;
        for (int i = 0; i < n; ++i){
            candList.add(nodeId + 10*(i+1) > totalNum ? totalNum - 10*(i+1) : nodeId + 10*(i+1));
        }
        return candList;
    }

}
