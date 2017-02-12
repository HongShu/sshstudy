# Spring无XML配置

```java
public class FunService {
	public String showHello(String word){
		return "Hello "+word;
	}
}

public class UseFunService {
	FunService funService;
	public FunService getFunService() {
		return funService;
	}
	public void setFunService(FunService funService) {
		this.funService = funService;
	}
	public String showHello(String word) {
		return funService.showHello(word);
	}
}

/**
*省略了package和impor语句,此java类用来取代xml配置bean
*
*/
@Configuration
public class JavaConfig {
    //声明bean的类型为FunService类型，bean的名字为funService
	@Bean
	public FunService funService(){
		return new FunService();
	}
  	//声明bean的类型为UseFunService，bean的名字为useFunService
    //此方法参数声明中的funService的bean为上面声明的bean
	@Bean
	public UseFunService useFunService(FunService funService){
		UseFunService useFunService = new UseFunService();
		useFunService.setFunService(funService);
		return useFunService;
	}
}

//使用刚才的java类，生成一个AnnotationConfigApplicationContext的context实例。
public class Test {
	public static void main(String[] args) {
		AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(JavaConfig.class);
		UseFunService useUserService = context.getBean(UseFunService.class);
		System.out.println(useUserService.showHello("Spring annotation!"));
		context.close();
	}
}
```



# Spring切面

## 1.基本概念

advice:切面具体的功能是什么？以及在什么时间（方法前、方法后）执行？

Pointcut:定义在何处（哪些方法上）执行？

切面是一个类，它里面包含了切点的处理代码（即pointcut指向的代码 ）。

## 2.基本使用

```java
//此案例使用了aspectj注解，需要导入aspectjrt.jar和aspectjweaver.jar包
/**
 * 切点由使用了Action注解来声明
 */
@Target(ElementType.METHOD)		//注解用在方法上
@Retention(RetentionPolicy.RUNTIME)	//注解在运行期生效
@Documented
public @interface Action {
	String name();
}
/**
*此类的add方法由@Action指定的注解来说明它是一个切点
*/
@Service
public class DemoAnnotationService {
	@Action(name="注解式拦截的add操作")
	public void add(){
		System.out.println("-->DemoAnnotationService.add();");
	}
}
// 此类的add方法，没有用@Action注解来声明切点
@Service
public class DemoMethodService {
	public void add(){
		System.out.println("-->DemoMethodService.add()");
	}
}
/**
 * 这里的JavaConfig类和切面中的@Pointcut一样，没有具体的代码，
 * 真正起作用的是它们上面的注解。实际上就是为了把以前写在xml中的配置信息
 * 以注解的方式放在空类、空方法的前面。
 */
@Configuration
@ComponentScan("com.aop")
@EnableAspectJAutoProxy  //开启spring对AspectJ的支持
public class JavaConfig {
}


@Aspect
@Component
public class LogAspect {
	/**
	 *定义切点
	 * 名字：annotationPointCut，就是方法名
	 * 位置：（何处）是由@action注解声明的方法。
	 */
	@Pointcut("@annotation(com.aop.Action)")
	public void annotationPointCut(){};
	/**
	* 定义通知
	*关联切点：上面定义
	*时机：切点代码执行后。
	*处理：方法体
	 */
	@After("annotationPointCut()")   
	public void after(JoinPoint joinPoint){
		MethodSignature signature = (MethodSignature) joinPoint.getSignature();
		Method method = signature.getMethod();
		Action action = method.getAnnotation(Action.class);
		System.out.println("注解式拦截："+action.name());
	}
	/**
	 * 定义通知
	 *关联切点：SPEL指定
	 *时机：切点方法执行前
	 *处理：方法体
	 */
	@Before("execution(* com.aop.DemoMethodService.*(..))")
	public void before(JoinPoint joinPoint){
		MethodSignature signature = (MethodSignature) joinPoint.getSignature();
		Method m = signature.getMethod();
		System.out.println("方法规则式拦截："+m.getName());
	}
}

public class Test {
	public static void main(String[] args) {
		AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(JavaConfig.class);
		DemoAnnotationService demoAnnotationService = context.getBean(DemoAnnotationService.class);
		demoAnnotationService.add();
		
		System.out.println();
		DemoMethodService demoMethodService = context.getBean(DemoMethodService.class);
		demoMethodService.add();
	}
}
```

# Spring MVC笔记（基于xml文件）

1. 在web.xml中配置一个Servlet，在应用启动之初就开始启动

```java
<servlet>
  <servlet-name>spitter</servlet-name>
  <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
  <init-param>
      <param-name>load-on-startup</param-name>
      <param-value>1</param-value>
   </init-param>
</servlet>
<servlet-mapping>
    <servlet-name>spitter</servlet-name>
    <url-pattern>/</url-pattern>
</servlet-mapping>
```

2.在WEB-INF下面新建一个spitter-servlet.xml文件。

```java
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:aop="http://www.springframework.org/schema/aop"
	xmlns:tx="http://www.springframework.org/schema/tx" xmlns:mvc="http://www.springframework.org/schema/mvc"
	xmlns:context="http://www.springframework.org/schema/context"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-4.3.xsd
    http://www.springframework.org/schema/mvc
    http://www.springframework.org/schema/mvc/spring-mvc-4.3.xsd
	http://www.springframework.org/schema/context
    http://www.springframework.org/schema/context/spring-context-4.3.xsd
    ">
	<!--  所有以resources开发的资源请求，都会由应用程序根路径下的/resources目录提供服务，不经过servlet -->
	<mvc:resources mapping="/resources/**" location="/resources/*" ></mvc:resources>

	<!-- 注册了多个特性：JSR-303校验、信息转换、对域格式的支持。 -->
	<mvc:annotation-driven />

	<!--查找使用@Component注解的类，并将其注册为Bean。@Controller注解是@Component注解的具体化。-->
  <context:component-scan base-package="com.controller" >
  </context:component-scan>
	
  <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
          <property name="prefix" value="/WEB-INF/view/"></property>
          <property name="suffix" value=".jsp"></property>
  </bean>
      
  <bean id="spitterService" class="com.controller.SpitterService">
  </bean>
</beans>
```

3.新建一个Controller

```JAVA
@Controller
public class HomeController {	
	@RequestMapping({"/","/home"})
	public String showHomePage(Map<String,Object> model){
		model.put("message", "message from spring mvc!");
		return "home";
	}	
}
```

# Spring MVC笔记（基于注解）

> 基于spring4.3 ，参考spring in action第4版，由于应用了servlet3.0中引入的注解配置servlet机制，因此部署时至少采用tomcat7.0以上的版本。

```java
package spittr.config;
//省略import
public class SpittrWebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {
	/**
	 * Servlet监听器的目的ContextLoaderListener
	 * 配置中间层、数据层组件
	 */
	@Override
	protected Class<?>[] getRootConfigClasses() {
		return new Class<?>[]{RootConfig.class};
	}
	/**
	 * DispatcherServlet:创建spring上下文
	 * 加载web组建的bean，如控制器、视图解析器、配置类中声明的bean
	 */
	@Override
	protected Class<?>[] getServletConfigClasses() {
		return new Class<?>[]{WebConfig.class};
	}
  /**
    * 所有的请求，都交给spring处理
    */
	@Override
	protected String[] getServletMappings() {
		return new String[]{"/"};
	}
}
```

代码解析：

1. Servlet3.0的环境中，容器会在类路径中查找实现javax.servlet.ServletContainerInitializer接口的类，若找到，则用它配置servlet容器。
2. Spring中有一个SpringServletContainerInitializer类，实现上述接口。但是这个类并不是直接配置这些信息，而是查找一个实现了WebApplicationInitializer接口的类，并将配置任务交给它。
3. AbstractAnnotationConfigDispatcherServletInitializer实现了WebApplicationInitializer接口，所以我们自己定义的类，只要实现这个抽象类就可以了。

WebConfig.java

```java
package spittr.config;
//省略import
@Configuration
@EnableWebMvc
//控制器等放置在该包下，且配置了@Configuration注解
@ComponentScan("spitter.web")
public class WebConfig extends WebMvcConfigurerAdapter {
	//配置静态资源的处理	
  @Override
	public void configureDefaultServletHandling(
			DefaultServletHandlerConfigurer configurer) {
		configurer.enable();
	}
  //配置jsp视图解析器
	@Bean
	public ViewResolver viewResolver(){
		InternalResourceViewResolver resolver = new InternalResourceViewResolver();
		resolver.setPrefix("/WEB-INF/views/");
		resolver.setSuffix(".jsp");
		resolver.setExposeContextBeansAsAttributes(true);
		return resolver;
	}
}
```

RootConfig.java

```java
package spittr.config;
// import ....
@Configuration
@ComponentScan(basePackages = { "spitter" }, excludeFilters = { @Filter(type = FilterType.ANNOTATION, value = EnableWebMvc.class) })
public class RootConfig {

}
```

HomeControllerTest.java

```JAVA
package spittr.test;
//import ....
public class HomeControllerTest {
	@Test
	public void testHomePage() throws Exception {
		HomeController controller = new HomeController();
		MockMvc mockMvc = MockMvcBuilders.standaloneSetup(controller).build();	mockMvc.perform(MockMvcRequestBuilders.get("/")).andExpect(
				MockMvcResultMatchers.view().name("home"));
	}
}
```


# 参数传递
## 1.查询参数

public String home(@RequestParam("max") long max)

## 2.表单参数

public String home(User user) user对象的属性会使用请求对象中同名的参数填充

## 3.路径变量

@PathVarible("max") long max

# action获取reqeust、session中的属性（未解决）

请求参数中各个属性：Model ==》MVC中的Model，用于Controller向View传递数据的载体，Map类型的数据。
HttpSession session ,HttpServletRequest request,Locale localde 可以作为参数放置在Controller的参数声明中。以实现对request、session等属性的访问。

# 请求转发与重定向（未解决）

重定向: return "redirect:/product_view/1";

*重定向的时候携带数据：*
1.地址栏参数：不安全，不应该采用
2.model.addFlashAttribute()的方式，该属性在重定向之后仍然能够访问。
另一种实现方式：
Controller中添加参数：RedirectAttributes redirectAttributes
redirectAttributes.addFlashAttribute("message","msg before redirect");

#表单校验

1.为实体类的各个属性添加校验注解。（比如：@Digits @NotNulls）

2.Controll的方法声明

```JAVA
public String home(@Valid User user,Errors errors){
  if(errors.hasErrors()){
    return "registerForm";
  }
}
```

# Spring标签库：

> 渲染html表单标签（绑定model中的某个属性）、工具类标签

```jsp
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="sf"%>

<sf:form method="" action="" commandName="User">
	FirstName:<sf:input path="firstName" />
</sf:form>

<sf:errors path="firstName" cssClass="error" />
span.error{color:red;}

//几种展示错误信息
<sf:errors path="*" element="div" cssClass="errors" />

```

中文提示的错误信息：

```java
//1.属性字段指定提示信息
@NotNull
@Size(min=5,max=25,message="{username.size}")   //若无大括号，则message里面的值作为普通的字符串处理。
private String username;
//2.创建ValidationMessage.properties放在根类路径下，ValidationErrors_zh.properties 中文
username.size=username must be between {min} and {max}characters longs.
```





# Spring文件上传

DispatcherServlet将解析multipart请求数据的功能委托给了spring中MultipartResolver策略接口的实现，通过这个实现类来解析multipart请求中的内容。内置两个：

CommonsMultipartResolver：依赖于ComonsFileUpload解析multipart请求

StandardServletMultipartResolver:依赖于Servlet3.0对multipart请求的支持（spring3.1以后的版本）==》首选方案。

```java
//在spring的应用上下文中配置bean（WebConfig）
@Bean
public MultipartResolver multipartResolver(){
  return new StandardServletMultipartResolver();
}
```

```java
//对上传文件的控制
public class SpittrWebAppInitializer extends
	AbstractAnnotationConfigDispatcherServletInitializer {
 	@Override
	protected  void customizeRegistration(Dynamic registration) {
      //接收的参数为文件系统中的绝对路径,文件大小不超过2mb,请求不超过4mb，所有文件都要写入磁盘。
		registration.setMultipartConfig(new MultipartConfigElement(
				"/tmp/spittr/uploads",2097152,4194304,0));
	} 
}
```

```html
<!--此jsp文件的映射路径为get请求的／home，表单没有添加action属性，则它会自动post到／home的 -->
<form method="post" enctype="multipart/form-data">
    		
    		班级编号：<input name="id" />
    		<br/>
    		班级名称：<input name="roomName" />
    		<br/>
    		<label>Profile Picture:</label>
    		<input type="file" name="profilePicture" accept="image/jpeg,image/png,image/gif" />
    		<input type="submit" />
    </form>
```



```java
@RequestMapping(path="/room",method=RequestMethod.POST)
	public String room2(@RequestPart("profilePicture") MultipartFile multipartFile,Room room){
		System.out.println(room.getId());
		System.out.println(room.getRoomName());
		try {
			multipartFile.transferTo(new File("/Users/hs/Downloads/upload.jpg"));
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return "rooms";
	}
```



# 异常处理

Spring的一些异常会默认映射为http状态码，即在产生异常之后，相当于发回了错误状态码，页面效果如下所示：

```java
HTTP Status 500 - MyException
type Status report
message MyException
description The server encountered an internal error that prevented it from fulfilling this request.
```

如果要自定义的异常能够产生这样的效果，可以采用@ResponseStatus：的方式设置异常与http错误状态码之间的关系。

```java
@ResponseStatus(value=HttpStatus.INTERNAL_SERVER_ERROR,reason="MyException")
public class MyException extends  RuntimeException {
}
```



为同一个action中的所有异常配置一个统一的错误处理：

```java
@ExceptionHandler(MyException.class)
public String handleException(){
  return "rooms";
}
```

为所有的action配置一个统一的异常处理。

==》Spring3.2使用控制器通知类实现该目标。

控制器通知：带有@ControllerAdvice注解的类（应用到整个应用中带有@RequestMapping注解的方法上），其中包含有如下注解声明的方法：@ExceptionHandler、@InitBinder、@Modelattribute

@ControllerAdvice已经使用过了@Component注解，会被自动扫描到。



# Spring数据库访问

1.数据访问哲学：编写良好的Repository以接口的方式暴露功能。

2.将所有的SQLException异常包装成各种各样的DataAccessException，这是一个运行时异常。

3.数据访问模版化：让我们只用关心业务逻辑，其他的模版代码交给spring为我们完成。

impotant tips：Spring所支持的大多数持久化功能都依赖于数据源。因此在声明模版和Repository之前，我们需要在Spring中配置一个数据源来连接数据库。

三种数据源：推荐程度从高到低。

- JNDI查找的数据源
- 连接池的数据源
- JDBC驱动程序定义

## 一、配置数据源

### 1.配置JNDI数据源

#### 1）xml配置

```xml
<jee:jndi-lookup id="dataSource" jndi-name="/jdbc/SpitterDS" resource-ref="true" />
```

#### 2）java配置

```JAVA
@Bean
public JndiObjectFactoryBean dataSource(){
  JndiObjectFactoryBean jndiObjectFB = new JndiObjectFactoryBean();
  jndiObjectFB.setJndiName("jdbc/SpitterDS");
  // 自动给jndi名称加上java:comp/env/
  jndiObjectFB.setResourceRef(true);
  jndiObjectFB.setProxyInterFace(javax.sql.DataSource.class);
}
```

### 2. 配置数据源连接池

#### 1）xml配置

```xml
<bean
      id="dataSource"
      class="org.apache.commons.dbcp.BasicDataSource"
      p:driverClassName="com.mysql.jdbc.Driver"
      p:username="sa"
      p:password=""
      p:initialSize="5"
      p:maxActive="10"
/>
```

#### 2）java配置

```JAVA
@Bean
public BasicDataSource dataSource(){
  	BasicDataSource ds = new BasicDataSource();
  	ds.setDriverClassName("com.mysql.jdbc.Driver");
  	ds.setUsername("sa");
  	ds.setPassword("");
  	ds.setInitialSize(5);
  	ds.setMaxActive(10);
   	return ds;
}
```

### 3.配置JDBC驱动的数据源

位于包：org.springframework.jdbc.datasource

类名:DriverManagerDataSource、SimpleDriverDataSource、SingleConnectionDataSource

```java
@Bean
	public DataSource dataSource(){
	  	DriverManagerDataSource ds = new DriverManagerDataSource();
	  	ds.setDriverClassName("com.mysql.jdbc.Driver");
	  	ds.setUsername("root");
	  	ds.setPassword("hs110528");
	  	ds.setUrl("jdbc:mysql://localhost:3306/evaluation");
	   	return ds;
	}
```



### 4.使用嵌入数据库

### 5.使用profile选择数据源

## 二、使用JDBC模版

- JdbcTemplate（首选）
- NamedParameterJdbcTemplate
- SimpleJdbcTemplate（spring3.1废弃）

```java
@Bean
	public JdbcTemplate jdbcTemplate(DataSource dataSource){
		return new JdbcTemplate(dataSource);
	}

```

```JAVA
package com.anno.auto;
@Repository
public class CourseDao {
	private JdbcOperations jdbcOperations;
	@Inject
	public CourseDao(JdbcOperations jdbcOperations) {
		super();
		this.jdbcOperations = jdbcOperations;
	}
	public Course findOne(long id) {
		String sql = "select * from course where course_id=?";
		return jdbcOperations.queryForObject(sql, new CourseRowMapper(), id);
	}

	public List<Course> findCoursesByClassName(String className) {
		String sql = "select * from course where class_name=?";
		return jdbcOperations.query(sql, new CourseRowMapper(), className);
	}

	public List<String> findAllClassNames() {
		String sql = "select distinct(class_name) from course";
		return jdbcOperations.queryForList(sql, String.class);
	}

	// 增加评分信息
	public void addEvaluation(Evaluation evaluation) {
		String sql = "insert into evaluation(fk_course_id,score)values(?,?)";
		jdbcOperations.update(sql, evaluation.getFkCourseId(),
				evaluation.getScore());
	}

	// 批量增加评分信息
	public void addAllEvaluation(List<Evaluation> evaluations) {
		if (evaluations != null) {
			for (Evaluation evaluation : evaluations) {
				addEvaluation(evaluation);
			}
		}
	}
}

class CourseRowMapper implements RowMapper<Course> {
	@Override
	public Course mapRow(ResultSet rs, int rowNum) throws SQLException {

		return new Course(rs.getInt(1), rs.getString(2), rs.getString(3),
				rs.getString(4));
	}
}

```

 复杂sql语句拼接使用

```java
private static final String INSERT_USER ="insert into User(username, password) values(:username,:password)";
public void addUser(User user){
  Map<String,Object> map = new HashMap<String,Object>();
  map.put("username",user.getUsername);
  map.put("password",user.getPassword);
  jdbcOperations.update(INSERT_USER,map);
}
```

## 三、Spring与Hibernate（未验证）

## 四、Spring与JPA

### 1.配置实体管理器工厂（entity manager factory）

>基于JPA的应用需要使用EntityManagerFactory的实现类来获取EntityManager实例。

Application-managed：使用不运行JavaEE容器的应用，程序负责打开或关闭实体管理器并在事务中对其进行控制。
Container-managed：实体管理器由JavaEE创建和管理。
以上的两种实体管理器都实现了EntityManager接口。两者的区别在于EntityManager的创建和管理方式。

- 应用程序管理
  PersistenceProvider.createEntityManagerFactory()==>EntityManagerFactory==>EntityManager
- 容器管理(此种场景，spring会担当容器的角色)
  PersistenceProvider.createContainerEntityManagerFactory()==>EntityManagerFactory==>EntityManager

以上是实现原理，不理解也不影响使用。

LocalContainerEntityManagerFactoryBean 配置这个bean，实现容器管理类型的“实体管理器”工厂的创建。

```java
@Bean
	public LocalContainerEntityManagerFactoryBean entityManagerFactory(
			DataSource dataSource, JpaVendorAdapter jpaVendorAdapter) {
		LocalContainerEntityManagerFactoryBean emfb = new LocalContainerEntityManagerFactoryBean();
		emfb.setDataSource(dataSource);
		emfb.setJpaVendorAdapter(jpaVendorAdapter);
      //persistence.xml文件的主要作用在于识别持久化单元中的实体类。从Spring 3.1开始，我们能够在LocalContainerEntityManagerFactoryBean中直接设置packagesToScan属性。
      //此配置会自动扫描com.hbxtzy.entity中带有@Entity注解的类。由于DataSource也已经配置过了，因此完全可以省略原有JPA所需要的persistence.xml文件。
      emfb.setPackagesToScan("com.hbxtzy.entity");
		return emfb;
	}
//JpaVendorAdapter的实现类EclipseLinkJpaVendorAdapter、OpenJpaVendorAdapter
	@Bean
	public JpaVendorAdapter jpaVendorAdapter(){
		HibernateJpaVendorAdapter adapter = new HibernateJpaVendorAdapter();
		adapter.setDatabase(Database.MYSQL);
		adapter.setGenerateDdl(false);
		adapter.setShowSql(true);
      adapter.setDatabasePlatform("org.hibernate.dialect.MySQL5Dialect");
		return adapter;
	}

```

tips：还可以通过JNDI来获取实体管理工厂。

### 代码调试过程

hibernate 3版本要求默认开启validator验证，会提示unable to get the default Bean Validation.异常，需要配置一个<property name="javax.persistence.validation.mode">none</property>

引入hibernate5之后，则会出现Unsupported major.minor version 52.0异常。原因是hibernate5采用jdk7进行编译的在myeclipse默认的jdk6下面运行会出错。

若采用jdk8，则会导致其他的类出现问题。

The type java.lang.CharSequence cannot be resolved. It is indirectly referenced from required .class files。

Java 8 supports [default methods](http://docs.oracle.com/javase/tutorial/java/IandI/defaultmethods.html) in interfaces. And in JDK 8 a lot of old interfaces now have new default methods. For example, [now in CharSequence we have chars and codePoints methods](http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/8-b132/java/lang/CharSequence.java#CharSequence.codePoints%28%29).
If source level of your project is lower than 1.8, then compiler doesn't allow you to use default methods in interfaces. So it cannot compile classes that directly on indirectly depend on this interfaces.
If I get your problem right, then you have two solutions. First solution is to rollback to JDK 7, then you will use old CharSequence interface without default methods. Second solution is to set source level of your project to 1.8, then your compiler will not complain about default methods in interfaces。

### 解决方案：

> 引入hibernate4.0的库

### 完整环境配置如下

mac

myeclipse 10

自带jdk1.6

hibernate 4.3.11

spring 4.3.3

spring-data-core-1.12.5

spring-data-jpa.1.10.5

