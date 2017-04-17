package com.aibasis.logging;

import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.core.pattern.CompositeConverter;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by hxx on 9/22/16.
 */
public class ColorConverter extends CompositeConverter<ILoggingEvent> {

    private static final Map<String, AnsiElement> ELEMENTS;

    static {
        Map<String, AnsiElement> elements = new HashMap<String, AnsiElement>();
        elements.put("faint", AnsiStyle.FAINT);
        elements.put("red", AnsiColor.RED);
        elements.put("green", AnsiColor.GREEN);
        elements.put("yellow", AnsiColor.YELLOW);
        elements.put("blue", AnsiColor.BLUE);
        elements.put("magenta", AnsiColor.MAGENTA);
        elements.put("cyan", AnsiColor.CYAN);
        ELEMENTS = Collections.unmodifiableMap(elements);
    }

    private static final Map<Integer, AnsiElement> LEVELS;

    static {
        Map<Integer, AnsiElement> levels = new HashMap<Integer, AnsiElement>();
        levels.put(Level.ERROR_INTEGER, AnsiColor.RED);
        levels.put(Level.WARN_INTEGER, AnsiColor.YELLOW);
        LEVELS = Collections.unmodifiableMap(levels);
    }

    @Override
    protected String transform(ILoggingEvent event, String in) {
        AnsiElement element = ELEMENTS.get(getFirstOption());
        if (element == null) {
            // Assume highlighting
            element = LEVELS.get(event.getLevel().toInteger());
            element = (element == null ? AnsiColor.GREEN : element);
        }
        return toAnsiString(in, element);
    }

    protected String toAnsiString(String in, AnsiElement element) {
        return AnsiOutput.toString(element, in);
    }

}
