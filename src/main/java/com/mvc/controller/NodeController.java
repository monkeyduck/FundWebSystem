package com.mvc.controller;

import com.mvc.model.Category;
import com.mvc.model.DTopic;
import com.mvc.model.DialogNode;
import com.mvc.model.NodeRelation;
import com.mvc.service.NodeService;
import com.utils.Utils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
/**
 * Created by llc on 16/11/2.
 */
@Controller
public class NodeController {

    private static final int categoryNum = 3;

    @Resource(name="NodeService")
    private NodeService nodeService;

    @RequestMapping("updown")
    public ModelAndView updown(){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("updown");
        return mv;
    }

    @RequestMapping("index")
    public ModelAndView index(){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("index");
        List<String> keyList = nodeService.getTopicKeys();
        List<String> categoryList = nodeService.getCategories();
        List<Category> categoryInfoList = new ArrayList<>();
        // category_id starts from 0
        for (int i = 0; i <= categoryNum; ++i) {
            int completeRate = (int)(calCompleteDegree(i) * 100);
            Category category = new Category(i, categoryList.get(i), completeRate);
            categoryInfoList.add(category);
        }
        StringBuilder data = new StringBuilder();
        keyList.forEach(key -> data.append(key + ","));
        mv.addObject("allTopics", data);
        mv.addObject("categoryInfo", categoryInfoList);
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

    private float calCompleteDegree(int categoryId) {
        int nodeNum = nodeService.getNodeNumByCategoryId(categoryId);
        int connNodeNum = nodeService.getConnectedNodeNumByCategoryId(categoryId);
        return Utils.floatPrecision(Utils.devide(connNodeNum,nodeNum), 2);
    }

}
