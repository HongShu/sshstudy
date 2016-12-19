# struts2学习笔记
> 尚学堂讲义

> git pull origin master 取回远程分支，与当前分支合并
>
> git push -u origin master  -u指定默认主机，以后可以不加任何参数使用 git push

> http://www.ruanyifeng.com/blog/2014/06/git_remote.html

# 坑

1.不要随意导入不需要的包，比如若你导入了restful相关的包，则action必须要拥有index方法，而且在zero-configuration模式下，不能实现chain的自动跳转。

#  IDEA用高版本的struts2



## 搭建第一个struts应用

- 下载struts2完整包
- 新建Web项目
- 拷贝struts2\app\struts2-blank下面的Jar包
- 修改web.xml文件,添加filter过滤器（Ctrl+shift+T快速打开查找类窗口）
```
<filter>
	<filter-name>struts2</filter-name>
	<filter-class>org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter</filter-class>
</filter>
<filter-mapping>
	<filter-name>struts2</filter-name>
	<url-pattern>/*</url-pattern>
</filter-mapping>
```
- 新建Action类，定义属性和public String execute()方法
- 拷贝struts2\app\src\目录下的struts.xml文件直项目的src目录下，根据项目需求修改该文件

```
 <package name="default" namespace="/" extends="struts-default">
    <action name="first" class="com.struts.test.FirstAction">
    	<result name="success">ok.jsp</result>
    </action>
</package>

namespace属性表示访问此包下的Action的前缀（必须以/开头）。
需要注意的是，若将本例中的namespace属性的值改为"/user"，则ok.jsp也要放在webroot下的/user文件夹下，否则会找不到ok.jsp页面。

```

```
//struts2标签引用
<%@ taglib prefix="s" uri="/struts-tags" %>
```


> struts乱码如何解决？在最简单的案例中，如何解决输入中文的问题。
> <constant name="struts.i18n.encoding" value="utf-8"></constant>

## 开发模式：修改action和xml不需要重新启动服务。
```java
<constant name="struts.devMode" value="true" />	

<constant name="struts.convention.classes.reload" value="true"/>配置信息更改时自动加载，不需要重启容器。

<constant name="struts.enable.DynamicMethodInvocation" value="true" /> 启用动态方法调用
```

## OGNL

###  关于OGNL的理解

框架在处理每个请求时都会创建该请求对应的运行环境＝＝》head first所谓的请求上下文？。

并将请求对应的action对象放在其中。

action对象被放在一个叫做值栈的对象中。

请求上下文(就是一个map)》》值栈》》action对象

值栈：框架创建的一个存储区域（一个虚拟对象），用来保存model对象。包含存放在其中的所有对象的所有属性。

ognl针对运行环境ActionContext（ValueStack\parameters\application\session\attr\request）的任何一个对象进行解析。

所有表达式的解析必须针对ActionContext的某个对象，也称为根对象。



访问Context对象的语法：#对象名称

所有表达式的解析必须针对ActionContext中的某个对象，这个对象也称为根对象，默认根对象是：值栈。

也可以通过明确指定名字的方式将其他对象作为根对象，比如：＃application.username==application.getAttribute("username");

------

值栈像一个栈一样工作，若采用的是model driver 开发，则当前的模型对象会放在action对象的前面。也就是青鸟教材上所展示的效果p116;

The Model Object

If you are using model objects in your struts application, the current model object is placed before the action on the value stack

ActionContext

​	context

​		_values

​			table(HashMap(k,v))

table内部有很多的键值对，也就是valueStack\request\session等。

valueStack包含如下对象：

Temporary Objects 标签迭代的时候临时变量

Model Object Model drivern驱动时的model对象

Action Object

Named objects

\#application #session #request等

HashMap内部包含一些对象，有的对象又是HashMap的，即MAP嵌套Map的结构。

ActionContext中存放的并不是真正的reqeust和session对象，只是将这些属性封装在一个Hasmap中而已。



> 来源：[ [Struts2数据传输的背后机制：ValueStack（值栈）](http://blog.csdn.net/li_tengfei/article/details/6098134)
>
> ](http://blog.csdn.net/li_tengfei/article/details/6098134)
>
> 不能写代码的地方执行Java代码，实现对象内嵌套对象的属性导航。

```java
GrandPa gp = new GrandPa(new Father(new Son("HongShu")));
String value = (String)Ognl.getValue("father.son.name", gp);//访问根对象的属性，不需要修饰，直接用属性名就可以了。
System.out.println(value);

GrandPa grandPa3 = new GrandPa(new Father(new Son("LanShu")));
grandPa3.setType("C");
String value = (String)Ognl.getValue("type",grandPa3);
System.out.println(value);
//本例中，获取type属性的时候，没有指定要访问的是哪个对象的type属性，但是后面将root根对象设置为grandPa3,所以获取的实际上是grandPa3的type属性的值。
```

### Context对象

> 在需要访问多个毫不相关的对象的情景下，给OGNL传递一个Map对象，把所有要查询但是不关联的对象放在Map中。该Map即为Context对象。
>
> 访问Context对象的语法：#对象名称

```java
GrandPa grandPa1 = new GrandPa(new Father(new Son("HongShu")));
GrandPa grandPa2 = new GrandPa(new Father(new Son("ZiShu")));
grandPa1.setType("A");
grandPa2.setType("B");

Map<String, GrandPa> context = new HashMap<String, GrandPa>();
context.put("gp1", grandPa1);
context.put("gp2", grandPa2);

String value = (String) Ognl.getValue("#gp1.father.son.name", context, new Object());
String value2 = (String) Ognl.getValue("#gp2.type", context, new Object());
System.out.println(value+":"+value2);
//grandPa1和grandPa2是两个不同的对象，他们之间没有关联，但是在程序中，要求分别取出两个对象的某个内嵌属性，因此将两个对象放在一个Map中，作为一个Context来处理。
//若表达式中没有用到root对象，则可以用任意一个对象代表根对象，本例中是new Object();
//gp1不是根对象的属性，所以加了#
```

### OGNL给对象属性赋值

```
Ognl.setValue("type", grandPa3, "ABC");
System.out.println(grandPa3.getType());

Ognl.setValue("father.son.name", grandPa3, "HongShu");
System.out.println(grandPa3.getFather().getSon().getName());
```

### OGNL 调用Java 的方法

```
//Fahter的代码如下：
public class GrandPa {
	private Father father ;
	private String Type;
	public String sayHello(){
		return father.getSon().getName()+":"+Type;
	}
	//get\set方法省略
｝

System.out.println(Ognl.getValue("sayHello()", grandPa3));
//HongShu:C
```

### OGNL调用静态的方法和变量

### OGNL访问数组和集合对象

## 获取真正的HttpServletRequest对象

我们从ActionContext获取的数据实际上并不是真正的请求对象，只是struts2将请求中的数据获取后，以hashmap的方式放置在ac中。

要取得真正的对象，可以使用：ServletActionContext.getReqeust();

ServletActionContext.getRequest().getSession();

ServletActionContext.getServletContext();

## OGNL访问

action是放在ValueStack中，而ValueStack是ognl默认的root，所以访问action中的属性是不需要带＃的。

比如：<s:property value="name" />

但是如果需要访问request参数，则需要带＃号，以告诉ognl不要在根对象中寻找。

比如：<s:property value="#request.rKey"/>

attr对象，依次从PageContext\request\session\application中获取参数。



运算符

1. 点运算符操作方便，常用
2. ［］使用复杂，但功能强大，可以传入变量值，动态取值。

＃reqeust.r的值为 5
＃parameters.param2[0]=r
则#request[#parameters.param2[0] = 5

in 与 not in
<s:property value="'a' in {'a','b','c'}" />  //true
<s:property value="'hs' in #request.m.values" />

集合操作：
过滤／投影(把过滤集合中的元素产生一个子集合，叫做投影。
？－－－符合选择逻辑的所有元素
^ －－－符合选择逻辑的第一个元素
$ －－－符合选择逻辑的最后一个元素
＃this －－－表示集合是的元素



## i18N

IDEA支持国际化资源文件的配置，直接在项目下新建Resource Bundle即可进行创建，可以指定要创建的国际化资源文件的类型，即支持哪些语言。英文：en_US,中文：zh_CN.在建立中文资源文件的时候，默认的中文并不会转换成unicode，再以asscii的方式保存，所以，需要让idea默认将中文转换，具体操作如下：

1. idea->preferences->editor->file encodings->勾选：transparent native-to-ascii conversion

2. 重新在properties文件中录入中文

## struts2的国际化

将资源文件放在源代码文件夹

在struts.xml文件中配置如下常量

<constant name='struts.custom.i18n.resource' value='app'></constant>

在页面中，可以使用如下方式获取；

<s:property value="getText('welcome.msg')" />

## idea部署tomcat与字体大小配置

环境字体：idea->preferences->Appearance&Behavior->Appearance->Override default fonts by(not recommended): 

编码字体：idea->proference->editor->colors & fonts ->font->当前主题另存为->调整字体大小

[http://www.escapist.me/intellij-idea-15-create-struts2-tomcat/](http://www.escapist.me/intellij-idea-15-create-struts2-tomcat/)

主要的坑：

1.在配置了tomcat之后，要求在项目的artifacts选项中，将struts2的jar包添加进构建项目中。

2.项目的发布路径不要发布在tomcat根路径下

3.File-Project Structure->Problems->fix



## %的用法

```java
<%
    request.setAttribute("a","aaa");
%>
<s:property value="#request.a" ></s:property>			//aaa
<s:textfield value="#reqeust.a"></s:textfield>			//#request.a
<s:textfield value="%{#request.a}"></s:textfield>		//aaa
 说明：在textfield控件的value属性中，并没有直接解析ognl表达式，需要加上％，才能当作ognl表达式执行。这就是％的用法。
```

## 拦截器

过滤器：过滤一切对象,函数回调实现

拦截器：只能拦截action，动态代理实现。

> 问题：学习某个知识点的时候，很容易陷入要研究这是如何实现的。特别是在教学时，这样的想法不太合适。初学某个新内容，应优先以应用为主，在有一定的了解之后，再来研究实现原理等深入的话题。

## 存在问题：token防止重复提交

## 自定义拦截器

1. 直接或间接实现com.opensymphony.xwork2.interceptor.Interceptor
```java
public String intercept(ActionInvocation ai) throws Exception{
  //1.获取action对象
  UserAction ua = (UserAction)ai.getAction();
  //...业务逻辑代码
  ai.invoke();//转到其他的拦截器
  //2.取得ActionContext对象,剩下的与之前的笔记类似
  ActionContext ac = ai.getInvocationContext();
  //获取servlet中对象
  ServletActionContext.getRequest().getSession();
  	.getResponse();
  	.getServletContext();
  	
  
}
```
3.  在package标签内通过<interceptor>定义拦截器
4.  在action标签内通过<interceptor-ref>使用拦截器

## 方法拦截器：未研究

## 文件上传

1.Action中定义三个变量

```java
File upload;	//与jsp页面中的文件域同名
String uploadContentType;
String uploadFileName;
```

2.需要进一步研究：

- 上传多个文件
- 限定文件类型
- struts2上传进度条实现

## 拦截器栈

1.全局拦截器如何设置？

2.如何使用全局拦截器实现部分页面的拦截，需要经过登录才能访问？

```java
<interceptors>
    <interceptor name="myinter" class="com.hs.MyInterceptor"></interceptor>
	<interceptor-stack name="myInterStack">
        <interceptor-ref name="defaultStack"></interceptor-ref>
        <interceptor-ref name="myinter"></interceptor-ref>
	</interceptor-stack>
</interceptors>

<action name="user" class="com.hs.UserAction">
    <interceptor-ref name="myinterStack"></interceptor-ref>
    <result name="success">ok.jsp</result>
</action>
```

## 验证

### 1.通过代码实现验证

让Action继承自ActionSupport类，向Action添加一个validate方法。

配置Action，当返回结果为input时，重新返回当前页面。

具体代码如下：

```java
 
<package name="validate" extends="struts-default" namespace="/validate">
  	<action name="empinfo" class="com.validate.Employee" method="execute">
    	<result name="input">index.jsp</result>
    	<result name="success">success.jsp</result>
    </action>
</package>

public class Employee extends ActionSupport {
    // 私有属性和公有访问器都省略
    public String execute(){
        return SUCCESS;
    }
    public void validate(){
        if(name == null || name.trim().equals("")){
            addFieldError("name","The name is required!");
           //此处的name是表单字段的名字
        }
        if(age < 28 || age > 65){
            addFieldError("age","The age must be between 28 and 65!");
        }
    }
```

### 2.xml Based validation

和action同包，建立一个action-validation.xml文件

```java
Employee2-validation.xml

<!DOCTYPE validators PUBLIC
        "-//Apache Struts//XWork Validator 1.0.3//EN"
        "http://struts.apache.org/dtds/xwork-validator-1.0.3.dtd">
<!-- 
    上面的xml文档声明，需要查看xwork-core.jar包。了解有哪些dtd文件。
-->

<validators>
   <field name="name">
      <field-validator type="required">
         <message>
            The name is required.
         </message>
      </field-validator>
   </field>

   <field name="age">
     <field-validator type="int">
         <param name="min">29</param>
         <param name="max">64</param>
         <message>
            Age must be in between 28 and 65
         </message>
      </field-validator>
   </field>
</validators>
//Action继承自ActionSupport
//配置文件配置return input时跳转到index.jsp
```

## 注解



## 主题

制定主题的若干方式：simple theme\xhtml theme\css_xhtml theme

- 特定标签的theme属性
- form标签的theme属性
- 页面、request、session、application作用域的theme属性
- 在struts.properties文件中配置struts.ui.theme
```java
<s:form action="empinfo" method="post" theme="css_xhtml">
```

## 类型转换

```java
public class Environment {
    private String name;
	//省略get\set方法和构造方法
}

@Result(name="success",location = "system.jsp")
public class SystemDetails extends ActionSupport {
    private Environment environment = new Environment("Development");
    private String operateSystem = "Windows 8";
	//省略get\set方法
}

//不进行任何转换，系统会显示如下结果：
Environment:com.struts2.Environment@581b48b1 
Operating System:Windows 8

//添加转换方式
 //1.新建一个转换类。
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
//2.在web-inf/classes 目录下添加一个xwork-conversion.properties文件，内容如下
com.struts2.Environment = com.struts2.EnvironmentConverter
 
//转换后，会显示以下结果
Environment:Development 
Operating System:Windows 8
  
//如何理解？
```



## 异常处理

```java
//针对action配置异常页面
<action name="" class="" method="">
	  <exception-mapping exception="java.lang.NullPointException" result="error"></exception-mapping>
  
  	   <result name="error">error.jsp</result>
</action>
 //配置全局异常页面
  <struts>
  	<global-exception-mappings>
  		 <exception-mapping exception="java.lang.NullPointException" result="error"></exception-mapping>
  	</global-exception-mapping>
  </struts>
```

## Tags

## 与其他框架的集成

## Struts2零配置 

　>http://www.codejava.net/frameworks/struts/struts2-beginner-tutorial-with-convention-plugin-zero-configuration

自动扫描规则：

- 包名中包含struts、struts2、action、actions
- 匹配的包名下搜索
  - 实现了com.opensymphony.xwork2.Action接口，或者继承自ActionSupport类
  - 名字以Action结尾


Action与URL的匹配规则：

- 去掉类名中结尾的Action
- 将类名中的大小全部改成小些，多个单词以-分割
- 如果子包名在struts、struts2、action、actions的后面，则子包名会作为url的命名空间
  - com.struts2.services.FileDownload   /services/file-download

Action默认的方法：execute（）,2.5.2 默认的方法改成了index（更正：引入了restful相关的包，所以index为默认方法。）

results和jsp的惯例用法

- action方法之后，调用页面默认为：/WEB-INF/content/action名字-返回字符串.jsp(idea测试未通过)
  - 举例：/services/file-download 返回success时，默认匹配/services/file-download-success.jsp
- 如果找不到匹配的页面，它会以success为结果寻找页面，如果这个也找不到，它会返回404错误。
- 即时没有action，也可以访问WEB-INF/content目录下的jsp文件。
  - 举例：/WEB-INF/content/hello-world.jsp文件的访问路径是：/hello-world

需要的jar包：

asm、asm-commons、asm-tree、commons-fileupload、commons-io、commons-logging、commons-logging-api、freemarker、javassist、ognl、struts2-convention-plugin、struts2-core、xwork-core

一些案例说明：猜测action应该放在上面描述规则中的包下面，注解才能生效。

```java
 //跳转路径为/web-inf/content/different/url.jsp,原因是index方法作为默认的方法(更正：引入了restful相关的包，所以index为默认方法。)
    @Action("/different/url")
    public String index(){
        return SUCCESS;
    }
    //跳转路径为/web-inf/content/user-success.jsp 不是默认方法，需要加上-sucesss
    @Action("/user")
    public String doSome(){
        return SUCCESS;
    }


//当访问/foo路径时，web-inf/content／目录下没有foo-bar.jsp的页面，所以它会查找同一个包下的／foo-bar的action，因此会执行下面的bar方法，最后，程序返回web-inf/content/目录下的foo-bar-success.jsp页面
	@Action("/foo")
	public String foo(){
      return "bar";
	}

	@Action("/foo-bar")
	public String bar(){
      return "success";
	}
```

@Namespace("/content")   before class.definition of an actin's namespace  rather than based on Zero Configuration's conventions

@Result (name="success",value="/success.jsp")

- before class:global
- before method :current path

@Results({

​	@Result(name="success",location="/success.jsp"),

​	@Result(name="failure",location="failure.jsp")

})

@After @Before @BeforeResult 没有验证成功！

Validator Annotation：before field。checks if there are any conversion errors for a field and applies them if they exist.

@ResultPath :before class.change the location where results are stored.

@ParentPackage:before class.

@ExceptionMappings \@ExceptionMapping(exception="",result="",parems={})

@ConvertionErrorFieldValidator

@DateRangeFieldValidator

@DoubleRangeFieldValidator

@IntRangeFieldValidator

@RegexFieldValidator(a string field using a regular expression)

@RequiredFieldValidator\RequiredStringValidator

@StringLengthFieldValidator

@UrlValidator

@EmailValidator

@ExpressionValidator(an ognl expression \supplied regular expression)

@CustomValidator

@Conversion

@CreateIfNull:for field or method

@Element:for field or method

@Key

@KeyProperty

@TypeConversion

@Validators


















