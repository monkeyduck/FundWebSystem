package com.mvc.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * Created by linchuanli on 2017/8/17.
 */
@Repository
public class FundDaoImpl implements FundDao {
    @Autowired
    private SqlSessionTemplate sqlSession;
}
