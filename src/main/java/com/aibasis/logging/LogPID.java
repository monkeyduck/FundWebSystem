package com.aibasis.logging;


import ch.qos.logback.core.PropertyDefinerBase;

import java.lang.management.ManagementFactory;

/**
 * Created by hxx on 9/22/16.
 */
public class LogPID extends PropertyDefinerBase {
    private String propKey;

    public String getPropKey() {
        return propKey;
    }

    public void setPropKey(String propKey) {
        this.propKey = propKey;
    }

    public String getPropertyValue() {
        String name = ManagementFactory.getRuntimeMXBean().getName();
        String pid[] = name.split("@");
        return pid[0];
    }
}
