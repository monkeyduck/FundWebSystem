package com.mvc.controller;

import com.mvc.service.FundService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;

/**
 * Created by linchuanli on 2017/8/17.
 */
@Controller
public class FundController {
    @Resource(name="FundService")
    private FundService fundService;

    @RequestMapping("index")
    public ModelAndView index(@RequestParam(value = "topicId", defaultValue = "-1") int topicId){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("index");
        return mv;
    }
}
