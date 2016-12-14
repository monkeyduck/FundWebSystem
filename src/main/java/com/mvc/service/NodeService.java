package com.mvc.service;

import com.mvc.model.DTopic;
import com.mvc.model.NodeRelation;

import java.util.List;

/**
 * Created by llc on 16/11/17.
 */
public interface NodeService {
    List<Integer> getRelatedNodes(int srcId);

    List<String> getTopicKeys();

    List<Integer> getNodesByTopicId(int topicId);

    List<DTopic> getAllTopics();

    List<Integer> getLeafNodesByTopicId(int topicId);

    String getTopicById(int topicId);

    List<Integer> getConnectedNode(int nodeId);

    String getNodeContent(int nodeId);

    void updateRank(NodeRelation nodeRelation);

    void insertRank(NodeRelation nodeRelation);

    int getTopicIdByNodeId(int nodeId);

    int getRootIdByTopicId(int topicId);

    void clearRelationBySrcId(int srcId);

    void insertTopicCategory(DTopic topic);

}
