package com.struts2;

import org.apache.struts2.util.StrutsTypeConverter;

import java.util.Map;

/**
 * Created by hs on 2016/10/18.
 */
public class EnvironmentConverter extends StrutsTypeConverter {
    @Override
    public Object convertFromString(Map map, String[] strings, Class aClass) {
        return new Environment(strings[0]);
    }
    @Override
    public String convertToString(Map map, Object o) {
        Environment environment = (Environment)o;
        return environment == null ? null: environment.getName();
    }
}
