package com.mvc.model;

import com.http.HttpTookit;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by llc on 16/12/19.
 */
@Configuration
public class NodeManager {
    private static final Logger logger = LoggerFactory.getLogger(NodeManager.class);
    private static final String relatedTopicPath = "/topicbase/relatedTopic?id=";
    private static HttpTookit httpTookit = new HttpTookit();

    @Autowired
    private Environment environment;

    private String serverAddress() {
        if (environment.acceptsProfiles("alpha")){
            return "http://cbg.data.zixiaole.com:50777";
        }
        if (environment.acceptsProfiles("online")){
            return "http://cbg.data.zixiaole.com:50777";
        }
        return "http://localhost:50777";
    }

    public List<Integer> getCandidateNodeList(int nodeId) {
        String url = serverAddress() + relatedTopicPath + nodeId;
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
