package com.mvc.service;

import com.mvc.dao.FundDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * Created by linchuanli on 2017/8/17.
 */
@Service("FundService")
public class FundServiceImpl implements FundService{
    @Resource
    private FundDao fundDao;
}
