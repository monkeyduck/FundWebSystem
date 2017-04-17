package com.aibasis.logging;

import ch.qos.logback.classic.pattern.ExtendedThrowableProxyConverter;
import ch.qos.logback.classic.spi.IThrowableProxy;
import ch.qos.logback.core.CoreConstants;

/**
 * Created by hxx on 9/22/16.
 */
public class ExtendedWhitespaceThrowableProxyConverter
        extends ExtendedThrowableProxyConverter {

    @Override
    protected String throwableProxyToString(IThrowableProxy tp) {
        return CoreConstants.LINE_SEPARATOR + super.throwableProxyToString(tp)
                + CoreConstants.LINE_SEPARATOR;
    }

}
