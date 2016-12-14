package com.mvc.controller;


import com.mvc.service.FundService;

import javax.annotation.Resource;

/**
 * Created by linchuanli on 2017/8/17.
 */
public class Controller {

    @Resource(name="FundService")
    private FundService fundService;
}
