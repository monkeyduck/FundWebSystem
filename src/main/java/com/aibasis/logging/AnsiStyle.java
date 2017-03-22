package com.aibasis.logging;

/**
 * Created by hxx on 9/22/16.
 */
public enum AnsiStyle implements AnsiElement {

    NORMAL("0"),

    BOLD("1"),

    FAINT("2"),

    ITALIC("3"),

    UNDERLINE("4");

    private final String code;

    AnsiStyle(String code) {
        this.code = code;
    }

    @Override
    public String toString() {
        return this.code;
    }

}
