package com.mvc.service;

import com.mvc.dao.NodeDao;
import com.mvc.model.DTopic;
import com.mvc.model.NodeRelation;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by llc on 16/11/17.
 */
@Service("NodeService")
public class NodeServiceImpl implements NodeService {

    @Resource
    private NodeDao nodeDao;

    @Override
    public List<Integer> getRelatedNodes(int srcId) {
        return nodeDao.getRelatedNodes(srcId);
    }

    @Override
    public List<String> getTopicKeys() {
        return nodeDao.getTopicKeys();
    }

    @Override
    public List<Integer> getNodesByTopicId(int topicId) {
        return nodeDao.getNodesByTopicId(topicId);
    }

    @Override
    public List<DTopic> getAllTopics() {
        return nodeDao.getAllTopics();
    }

    @Override
    public List<Integer> getLeafNodesByTopicId(int topicId) {
        return nodeDao.getLeafNodesByTopicId(topicId);
    }

    @Override
    public String getTopicById(int topicId) {
        return nodeDao.getTopicById(topicId);
    }

    @Override
    public List<Integer> getConnectedNode(int nodeId) {
        return nodeDao.getConnectedNode(nodeId);
    }

    @Override
    public String getNodeContent(int nodeId) {
        return nodeDao.getNodeContent(nodeId);
    }

    @Override
    public void updateRank(NodeRelation nodeRelation) {
        nodeDao.updateRank(nodeRelation);
    }

    @Override
    public void insertRank(NodeRelation nodeRelation) {
        nodeDao.insertRank(nodeRelation);
    }

    @Override
    public int getTopicIdByNodeId(int nodeId) {
        return nodeDao.getTopicIdByNodeId(nodeId);
    }

    @Override
    public void clearRelationBySrcId(int srcId) {
        nodeDao.clearRelationBySrcId(srcId);
    }

    @Override
    public void insertTopicCategory(DTopic topic) {
        nodeDao.insertTopicCategory(topic);
    }

    @Override
    public int getNodeNumByCategoryId(int categoryId) {
        return nodeDao.getNodeNumByCategoryId(categoryId);
    }

    @Override
    public List<DTopic> getTopicsByCategoryId(int categoryId) {
        return nodeDao.getTopicsByCategoryId(categoryId);
    }

    @Override
    public List<DTopic> getTopicsByCategoryName(String categoryName) {
        return nodeDao.getTopicsByCategoryName(categoryName);
    }

    @Override
    public List<Integer> getConnectedNodesByTopicId(int topicId) {
        return nodeDao.getConnectedNodesByTopicId(topicId);
    }

    @Override
    public int getConnectedNodeNumByCategoryId(int categoryId) {
        return nodeDao.getConnectedNodeNumByCategoryId(categoryId);
    }

    @Override
    public List<String> getCategories() {
        return nodeDao.getCategories();
    }

    @Override
    public int getRootIdByTopicId(int topicId) {
        return nodeDao.getRootIdByTopicId(topicId);
    }


}
