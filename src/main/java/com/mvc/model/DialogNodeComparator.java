package com.mvc.model;

import java.util.Comparator;

/**
 * Created by llc on 17/2/8.
 */
public class DialogNodeComparator implements Comparator<DialogNode> {
    @Override
    public int compare(DialogNode o1, DialogNode o2) {
        return o1.getContent().compareTo(o2.getContent());
    }
}
