package com.mvc.service;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Created by llc on 16/8/18.
 */
public class ServiceHelper {
    private static FundService fundService;

    static {
        ApplicationContext ctx= new ClassPathXmlApplicationContext("spring-mybatis.xml");
        fundService = (FundService) ctx.getBean("FundService");
    }

    public static FundService getFundService(){
        return fundService;
    }

}
