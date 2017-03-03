# JPA注解

## 基本的注解

```java
@Entity
@Table(name="dept")

@Id
@GeneratedValue(strategy=GenerationType.IDENTITY)

@Column(name="name")
```



## 单向一对一

```java
//Dept表中有一列depManager（部门主管列），外键关联到User表的主键。

public class Dept{
  
  @OneToOne
  @JoinColumn(name="depManager")
  private User user;
  
}
```



## 双向一对一

```java
//在单向一对一的基础上，额外作一些处理
public class User{
  //此处加上mapperBy说明，user是被动方
  //也意味着是在dept中有外键关联到user表的
  @OneToOne(mappedBy="user")
  private Dept dept;
}

//说明：在添加数据时为了正常工作，需要双向同时设置。
dept.setUser(user);
user.setDept(Dept);

e.g.  
User user = new User();
user.setUname("n1");
user.setAge(18);
userRepository.save(user);

Dept dept = new Dept();
dept.setName("t1");
dept.setUser(user);
user.setDept(dept);
deptRepository.save(dept);
```

## 多对一与一对多

```java
//多个部门有同一个主管
public class Dept {	
	@ManyToOne
	@JoinColumn(name="depManager")
	private User user;
}

public class User{
    //默认情况下，hibernate采用的是lazy模式，即获取user的时候，并没有加载dept。再user对象上调用getDept()方法时，dept为空，所以，hibernate采用session获取。由于在获取user的时候，session已经关闭，所以会产生org.hibernate.LazyInitializationException.解决方案是将延迟加载改成积极加载。即设置fetch=FetchType.EAGER
  //这样当然会带来效率的问题，如何解决需要进一步研究。
 	@OneToMany(mappedBy="user",fetch=FetchType.EAGER)
	private List<Dept> depts;
}

//说明：和双向一对一一样，更新时双向设置
user.setDepts(depts);
dpet.setUser(user);
```



## 多对多

```JAVA
public class User{
  @ManyToMany(fetch=FetchType.EAGER)
  @JoinTable(name="userdog",
             joinColumns=@JoinColumn(name="user_id"),
             inverseJoinColumns=@JoinColumn(name="dog_id"))
	private List<Dog> dogs;  
}
user表和dog表之间是多对多的关系，具体表现形式为：额外有一张表，包括user_id和dog_id两各字段，作为联合主键，分别外键关联到user表和dog表的主键。
  
public class Dog{
	@ManyToMany(mappedBy="dogs",fetch=FetchType.EAGER)
	private List<User> users;
}
```

> 其他更特殊的用法暂为研究。比如，user_dog中有一个领用宠物时间的字段。