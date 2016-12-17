package com.mvc.dao;

import com.mvc.model.DTopic;
import com.mvc.model.NodeRelation;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by llc on 16/11/16.
 */
@Repository
public class NodeDaoImpl implements NodeDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    @Override
    public List<Integer> getRelatedNodes(int srcId) {
        return sqlSession.selectList("getRelatedNodes");
    }

    @Override
    public List<String> getTopicKeys() {
        return sqlSession.selectList("getTopicKeys");
    }

    @Override
    public List<Integer> getNodesByTopicId(int topicId) {
        return sqlSession.selectList("getNodesByTopicId");
    }

    @Override
    public List<DTopic> getAllTopics() {
        return sqlSession.selectList("getAllTopics");
    }

    @Override
    public List<Integer> getLeafNodesByTopicId(int topicId) {
        return sqlSession.selectList("getLeafNodesByTopicId");
    }

    @Override
    public String getTopicById(int topicId) {
        return sqlSession.selectOne("getTopicById");
    }

    @Override
    public List<Integer> getConnectedNode(int nodeId) {
        return sqlSession.selectList("getConnectedNode");
    }

    @Override
    public String getNodeContent(int nodeId) {
        return sqlSession.selectOne("getNodeContent");
    }

    @Override
    public void updateRank(NodeRelation nodeRelation) {
        sqlSession.update("updateRank");
    }

    @Override
    public void insertRank(NodeRelation nodeRelation) {
        sqlSession.insert("insertRank");
    }

    @Override
    public int getTopicIdByNodeId(int nodeId) {
        return sqlSession.selectOne("getTopicIdByNodeId");
    }

    @Override
    public void clearRelationBySrcId(int srcId) {
        sqlSession.delete("clearRelationBySrcId");
    }

    @Override
    public void insertTopicCategory(DTopic topic) {
        sqlSession.insert("insertTopicCategory");
    }

    @Override
    public int getNodeNumByCategoryId(int categoryId) {
        return sqlSession.selectOne("getNodeNumByCategoryId");
    }

    @Override
    public List<DTopic> getTopicsByCategoryId(int categoryId) {
        return sqlSession.selectList("getTopicsByCategoryId");
    }

    @Override
    public List<DTopic> getTopicsByCategoryName(String categoryName) {
        return sqlSession.selectList("getTopicsByCategoryName");
    }

    @Override
    public List<Integer> getConnectedNodesByTopicId(int topicId) {
        return sqlSession.selectList("getConnectedNodesByTopicId");
    }

    @Override
    public int getRootIdByTopicId(int topicId) {
        return sqlSession.selectOne("getRootIdByTopicId");
    }

    @Override
    public int getConnectedNodeNumByCategoryId(int categoryId) {
        return sqlSession.selectOne("getConnectedNodeNumByCategoryId");
    }

    @Override
    public List<String> getCategories() {
        return sqlSession.selectList("getCategories");
    }

}
