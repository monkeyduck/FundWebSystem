package com.mvc.model;

import com.http.HttpTookit;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;
/**
 * Created by llc on 16/12/19.
 */
public class NodeManager {
    private static final Logger logger = LoggerFactory.getLogger(NodeManager.class);
    private static final String serverAddress = "http://cbg.data.hixiaole.com:50777";
    private static final String relatedTopicPath = "/topicbase/relatedTopic?id=";
    private static HttpTookit httpTookit = new HttpTookit();

    public static List<Integer> getCandidateNodeList(int nodeId) {
        String url = serverAddress + relatedTopicPath + nodeId;
        List<Integer> candidateList = new ArrayList<>();
        try {
            String response = httpTookit.sendGet(url).toString();
            JSONObject json = JSONObject.fromObject(response);
            int retCode = json.getInt("retcode");
            if (retCode == 1) {
                JSONArray jArray = json.getJSONArray("retbody");
                int arraySize = jArray.size();
                for (int i = 0; i < arraySize; ++i) {
                    candidateList.add(jArray.getJSONObject(i).getInt("id"));
                }
            } else {
                throw new Exception("retCode: 0");
            }
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
        return candidateList;
    }
}
