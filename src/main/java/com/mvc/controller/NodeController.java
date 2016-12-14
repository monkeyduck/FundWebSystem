package com.mvc.controller;

import com.mvc.model.DTopic;
import com.mvc.model.DialogNode;
import com.mvc.model.NodeManagement;
import com.mvc.model.NodeRelation;
import com.mvc.service.NodeService;
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

    @Resource(name="NodeService")
    private NodeService nodeService;

    @RequestMapping("updown")
    public ModelAndView index(){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("updown");
        return mv;
    }

    @RequestMapping("index")
    public ModelAndView updown(){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("index");
        List<String> keyList = nodeService.getTopicKeys();
        StringBuilder data = new StringBuilder();
        keyList.forEach(key -> data.append(key + ","));
        mv.addObject("allTopics", data);
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
        List<DialogNode> ret = new ArrayList<>();
        List<Integer> candList = NodeManagement.getCandidates(id);
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
            NodeRelation relation = new NodeRelation(srcId, id, i+1);
            nodeService.insertRank(relation);
        }
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

}
