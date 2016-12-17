package com.utils;

import java.math.BigDecimal;

/**
 * Created by llc on 16/12/16.
 */
public class Utils {
    public static float floatPrecision(float val, int digit){
        BigDecimal b  =   new  BigDecimal(val);
        return b.setScale(digit, BigDecimal.ROUND_HALF_UP).floatValue();
    }

    public static float devide(int d1, int d2){
        if (d2==0) return 0f;
        else return (float)d1/d2;
    }
}
