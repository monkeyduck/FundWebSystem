package com.http;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.ParseException;
import org.apache.http.StatusLine;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;


/**
 * Created by llc on 16/7/22.
 */
public class HttpTookit {

    private final static Logger logger = LoggerFactory.getLogger(HttpTookit.class);

    private static final String APPLICATION_JSON = "application/json";

    private static final String CONTENT_TYPE_TEXT_JSON = "text/json";

    // HTTP GET request
    public StringBuffer sendGet(String url) throws Exception {

        HttpClient client = new DefaultHttpClient();
        HttpGet request = new HttpGet(url);

        HttpResponse response = client.execute(request);

        logger.info("\nSending 'GET' request to URL : " + url);
        logger.info("Response Code : " + response.getStatusLine().getStatusCode());

        BufferedReader rd = new BufferedReader(
                new InputStreamReader(response.getEntity().getContent()));

        StringBuffer result = new StringBuffer();
        String line = "";
        while ((line = rd.readLine()) != null) {
            result.append(line);
        }

        logger.info(result.toString());
        return result;
    }


    /**
     * 获取响应内容，针对MimeType为text/plan、text/json格式
     *
     * @param content
     *            响应内容
     * @param response
     *            HttpResponse对象
     * @param method
     *            请求方式 GET|POST
     * @return 转为UTF-8的字符串
     * @throws ParseException
     * @throws IOException
     * @author Jie
     * @date 2015-2-28
     */
    public static String parseRepsonse(StringBuilder content, HttpResponse response, String method) throws ParseException, IOException {
        StatusLine statusLine = response.getStatusLine();
        int statusCode = statusLine.getStatusCode();// 响应码
        String reasonPhrase = statusLine.getReasonPhrase();// 响应信息
        if (statusCode == 200) {// 请求成功
            HttpEntity entity = response.getEntity();
            logger.info("MineType:" + entity.getContentType().getValue());
            content.append(EntityUtils.toString(entity));
        } else {
            logger.error(method + "：code[" + statusCode + "],desc[" + reasonPhrase + "]");
        }
        return content.toString();
    }

}
