package com.struts2;

import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;


@Action("/details")
@Result(name="success",location = "system.jsp")
public class SystemDetails extends ActionSupport {
    private Environment environment = new Environment("Development");
    private String operateSystem = "Windows 8";
    public String execute(){
        return SUCCESS;
    }
    public Environment getEnvironment() {
        return environment;
    }
    public void setEnvironment(Environment environment) {
        this.environment = environment;
    }
    public String getOperateSystem() {
        return operateSystem;
    }
    public void setOperateSystem(String operateSystem) {
        this.operateSystem = operateSystem;
    }
}

