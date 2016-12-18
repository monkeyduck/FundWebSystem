package com.mvc.controller;

import com.mvc.model.*;
import com.mvc.service.NodeService;
import com.utils.Utils;
import net.sf.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.util.*;

/**
 * Created by llc on 16/11/2.
 */
@Controller
public class NodeController {

    private static final int categoryNum = 3;
    private static List<String> keyList = new ArrayList<>();
    private static List<String> categoryList = new ArrayList<>();

    @Resource(name="NodeService")
    private NodeService nodeService;

    @RequestMapping("updown")
    public ModelAndView updown(){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("updown");
        return mv;
    }

    @RequestMapping("graph")
    public ModelAndView graph(){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("graph");
        List<Category> categoryInfoList = new ArrayList<>();
        if (keyList.isEmpty()) {
            keyList = nodeService.getTopicKeys();
            categoryList = nodeService.getCategories();
        }
        for (int i = 0; i <= categoryNum; ++i) {
            int completeRate = (int)(calCompleteDegree(i) * 100);
            Category category = new Category(i, categoryList.get(i), completeRate);
            categoryInfoList.add(category);
        }
        mv.addObject("categoryInfo", categoryInfoList);
        return mv;
    }

    @RequestMapping("index")
    public ModelAndView index(){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("index");
        keyList = nodeService.getTopicKeys();
        categoryList = nodeService.getCategories();

        // 采用异步加载的方法替代,避免加载时间过长
//        List<Category> categoryInfoList = new ArrayList<>();
        // category_id starts from 0
//        for (int i = 0; i <= categoryNum; ++i) {
//            int completeRate = (int)(calCompleteDegree(i) * 100);
//            Category category = new Category(i, categoryList.get(i), completeRate);
//            categoryInfoList.add(category);
//        }
        StringBuilder data = new StringBuilder();
        keyList.forEach(key -> data.append(key + ","));
        mv.addObject("allTopics", data);
//        mv.addObject("categoryInfo", categoryInfoList);
        return mv;
    }

    @RequestMapping("getLeafNodesByTopicId")
    @ResponseBody
    public List<DialogNode> getLeafNodesByTopicId(@RequestParam("id") int topicId){
        List<DialogNode> ret = new ArrayList<>();
        List<Integer> nodeList = nodeService.getLeafNodesByTopicId(topicId);
        String topic = nodeService.getTopicById(topicId);
        nodeList.forEach(nodeId -> {
            String content = nodeService.getNodeContent(nodeId);
            DialogNode dialogNode = new DialogNode(nodeId, topic, content, isConnected(nodeId));
            ret.add(dialogNode);
        });
        return ret;
    }

    @RequestMapping("searchTopic")
    @ResponseBody
    public List<DTopic> searchTopic(@RequestParam("searchKey") String key){
        List<DTopic> topicList = nodeService.getAllTopics();
        List<DTopic> searchList = new ArrayList<>();
        topicList.forEach(topic -> {
            if (topic.getKey().contains(key)){
                searchList.add(topic);
            }
        });
        return searchList;
    }

    @RequestMapping("searchTargetTopic")
    @ResponseBody
    public DialogNode searchTargetTopic(@RequestParam("searchKey") String key){
        List<DTopic> topicList = nodeService.getAllTopics();
        for (DTopic topic : topicList) {
            if (topic.getKey().equals(key)) {
                int nodeId = nodeService.getRootIdByTopicId(topic.getId());
                return createDialogNodeByNodeId(nodeId);
            }
        }
        return null;
    }

    @RequestMapping("candidateNode")
    @ResponseBody
    public List<DialogNode> candidateNode(@RequestParam("id") int id){
        int topicNum = 1052;
        List<DialogNode> ret = new ArrayList<>();
        List<Integer> candList = new ArrayList<>();
        int topicId = nodeService.getTopicIdByNodeId(id);
        for (int i = 0; i < 10; ++i) {
            int topicIdCan = (topicId + i) % topicNum + 1;
            int nodeIdCan = nodeService.getRootIdByTopicId(topicIdCan);
            candList.add(nodeIdCan);
        }
        List<Integer> connectedList = nodeService.getConnectedNode(id);
        candList.forEach(nodeId -> {
            if (!connectedList.contains(nodeId)) {
                DialogNode dialogNode = createDialogNodeByNodeId(nodeId);
                ret.add(dialogNode);
            }
        });
        return ret;
    }


    @RequestMapping("connectedNode")
    @ResponseBody
    public List<DialogNode> getConnectedNode(@RequestParam("id") int id){
        List<Integer> connList = nodeService.getConnectedNode(id);
        List<DialogNode> ret = new ArrayList<>();
        connList.forEach(nodeId -> {
            ret.add(createDialogNodeByNodeId(nodeId));
        });
        return ret;
    }

    @RequestMapping("saveRank")
    @ResponseBody
    public void saveRank(@RequestParam("options") String ids){
        String[] idList = ids.split(",");
        int srcId = Integer.parseInt(idList[0]);
        nodeService.clearRelationBySrcId(srcId);
        for (int i = 1; i < idList.length; ++i){
            int id = Integer.parseInt(idList[i]);
            NodeRelation relation = new NodeRelation(srcId, id, i);
            nodeService.insertRank(relation);
        }
    }

    @RequestMapping("getNodeContent")
    @ResponseBody
    public List<String> getNodeContent(@RequestParam("nodeId") String nodeId) {
        int iNodeId = Integer.parseInt(nodeId);
        List<String> list = new ArrayList<>();
        String content = nodeService.getNodeContent(iNodeId);
        list.add(content);
        return list;
    }

    @RequestMapping("getTopicsByCategoryId")
    @ResponseBody
    public List<DTopic> getTopicsByCategoryId(@RequestParam("categoryId") String categoryId) {
        int iCateId = Integer.parseInt(categoryId);
        List<DTopic> topicListByCateId = nodeService.getTopicsByCategoryId(iCateId);
        return topicListByCateId;
    }

    @RequestMapping("getTopicsByCategoryIdOrdered")
    @ResponseBody
    public List<DTopic> getTopicsByCategoryIdOrdered(@RequestParam("categoryId") String categoryId) {
        int iCateId = Integer.parseInt(categoryId);
        List<DTopic> topicListByCateId = nodeService.getTopicsByCategoryId(iCateId);
        List<DTopic> sortedTopicList = new ArrayList<>();
        for (DTopic topic: topicListByCateId) {
            float complete = calCompleteDegreeOfTopic(topic.getId());
            topic.setComplete((int)(100 * complete));
            sortedTopicList.add(topic);
        }
        Collections.sort(sortedTopicList);
        return sortedTopicList;
    }

    @RequestMapping("getTopicsByCategoryName")
    @ResponseBody
    public List<DTopic> getTopicsByCategoryName(@RequestParam("categoryName") String categoryName){
        List<DTopic> topicList = nodeService.getTopicsByCategoryName(categoryName);
        return topicList;
    }

    @RequestMapping("listCategories")
    @ResponseBody
    public List<Category> listCategories(@RequestParam("num") int num) {
        List<Category> categoryInfoList = new ArrayList<>();
        // category_id starts from 0
        for (int i = 0; i <= num; ++i) {
            int completeRate = (int)(calCompleteDegree(i) * 100);
            Category category = new Category(i, categoryList.get(i), completeRate);
            categoryInfoList.add(category);
        }
        return categoryInfoList;
    }

    @RequestMapping("getGraphData")
    @ResponseBody
    public JSONObject getGraphData(@RequestParam("topicId") int topicId) {
        JSONObject json = new JSONObject();
        List<GraphNode> nodes = new ArrayList<>();
        List<GraphCategory> gCateList = new ArrayList<>();
        List<GraphLink> links = new ArrayList<>();
        List<Integer> cateList = new ArrayList<>();
        List<Integer> nodeList = new ArrayList<>();
        Set<Integer> nodeIdSet = new HashSet<>();

        int rootId = nodeService.getRootIdByTopicId(topicId);
        GraphNode gRoot = new GraphNode(rootId, nodeService.getNodeContent(rootId),
                calGraphCateByTopicId(topicId, cateList, gCateList), GraphNode.rootSize);
        nodes.add(gRoot);
        nodeIdSet.add(rootId);

        List<Integer> leafNodeList = nodeService.getLeafNodesByTopicId(topicId);
        for (int nodeId: leafNodeList) {
            if (!nodeIdSet.contains(nodeId)) {
                links.add(new GraphLink(calGnodeId(rootId, nodeList), calGnodeId(nodeId, nodeList)));
                nodes.add(new GraphNode(nodeId, nodeService.getNodeContent(nodeId),
                        calGraphCateByTopicId(topicId, cateList, gCateList), GraphNode.leafSize));
                nodeIdSet.add(nodeId);
                List<Integer> connectedNodeList = nodeService.getConnectedNode(nodeId);
                for (int connId: connectedNodeList) {
                    if (!nodeIdSet.contains(connId)) {
                        int connTopicId = nodeService.getTopicIdByNodeId(connId);
                        nodes.add(new GraphNode(connId, nodeService.getNodeContent(connId),
                                calGraphCateByTopicId(connTopicId, cateList, gCateList), GraphNode.rootSize));
                        nodeIdSet.add(connId);
                    }
                    links.add(new GraphLink(calGnodeId(nodeId, nodeList), calGnodeId(connId, nodeList)));
                }
            }

        }
        json.put("data", nodes);
        json.put("links", links);
        json.put("categories", gCateList);
        return json;
    }

    @RequestMapping("getTopicByTopicId")
    @ResponseBody
    public JSONObject getTopicByTopicId(@RequestParam("topicId") int topicId) {
        String topic = nodeService.getTopicById(topicId);
        JSONObject json = new JSONObject();
        json.put("topic", topic);
        return json;
    }

//    @RequestMapping("loadData")
//    public void storeCategory() {
//        File file = new File("/Users/linchuan/IdeaProjects/TreeNodeConnection/src/main/resources/category.txt");
//        try {
//            List<String> list = FileUtils.readLines(file);
//            list.forEach(l -> {
//                String[] split = l.split("\\t");
//                String a = split[0].trim();
//                a = a.replace("\uFEFF", "");
//                int id = Integer.valueOf(a) + 1;
//                int catId = Integer.parseInt(split[1]);
//                String category = split[2];
////                String category = split[3].substring(0,split[3].length()-4);
//                DTopic topic = new DTopic();
//                topic.setId(id);
//                topic.setCatId(catId);
//                topic.setCategory(category);
//                nodeService.insertTopicCategory(topic);
//                System.out.println(category);
//            });
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }

    public boolean isConnected(int nodeId){
        List<Integer> connList = nodeService.getConnectedNode(nodeId);
        return !connList.isEmpty();
    }

    private DialogNode createDialogNodeByNodeId(int nodeId){
        String content = nodeService.getNodeContent(nodeId);
        int topicId = nodeService.getTopicIdByNodeId(nodeId);
        String topic = nodeService.getTopicById(topicId);
        return new DialogNode(nodeId, topic, content);
    }

    /**
     * 这种计算方法是用已关联叶子节点数/所有叶子节点数,更精确但是很慢
     * @param categoryId
     * @return
     */
//    private float calCompleteDegree(int categoryId) {
//        List<DTopic> topicIdList = nodeService.getTopicsByCategoryId(categoryId);
//        int leafNodeNum = 0;
//        for (DTopic topic: topicIdList) {
//            List<Integer> list = nodeService.getLeafNodesByTopicId(topic.getId());
//            leafNodeNum += list.size();
//        }
//        int connNodeNum = nodeService.getConnectedNodeNumByCategoryId(categoryId);
//        return Utils.floatPrecision(Utils.devide(connNodeNum, leafNodeNum), 2);
//    }

    /**
     * 这种方法是用已关联叶子节点数/所有节点数, 快但是会有非叶子节点混入导致结果不能到100%
     * @param categoryId
     * @return
     */
    private float calCompleteDegree(int categoryId) {
        int nodeNum = nodeService.getNodeNumByCategoryId(categoryId);
        int connNum = nodeService.getConnectedNodeNumByCategoryId(categoryId);
        return Utils.floatPrecision(Utils.devide(connNum, nodeNum), 2);
    }

    private float calCompleteDegreeOfTopic(int topicId) {
        int leafNodeNum = nodeService.getLeafNodesByTopicId(topicId).size();
        List<Integer> connList = nodeService.getConnectedNodesByTopicId(topicId);
        int connNodeNum = connList.size();
        return Utils.floatPrecision(Utils.devide(connNodeNum, leafNodeNum), 2);
    }

    private int calGraphCateByTopicId(int topicId, List<Integer> cateList, List<GraphCategory> gCateList) {
        if (cateList.indexOf(topicId) != -1) {
            return cateList.indexOf(topicId);
        } else {
            cateList.add(topicId);
            String topicName = nodeService.getTopicById(topicId);
            gCateList.add(new GraphCategory(topicName));
            return cateList.size() - 1;
        }
    }

    private int calGnodeId(int nodeId, List<Integer> nodeIdList) {
        if (nodeIdList.indexOf(nodeId) != -1) {
            return nodeIdList.indexOf(nodeId);
        } else {
            nodeIdList.add(nodeId);
            return nodeIdList.size() - 1;
        }
    }

}
