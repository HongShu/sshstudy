package junit.test;


import org.junit.BeforeClass;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import cn.hbxtzy.bean.Person;
import cn.hbxtzy.service.PersonService;

public class PersonServiceBeanTest {
	private static PersonService personService;
	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		try {
			personService = (PersonService) context.getBean("personService");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	@Test
	public void save(){
		personService.save(new Person("itcast"));
	}
	
	@Test
	public void delete(){
		personService.delete(7);
	}
	@Test
	public void update(){
		personService.update(new Person(6,"hbxtzy"));
	}
	@Test
	public void find(){
		System.out.println(personService.getPerson(6).getName());
	}
	
	@Test public void getAll(){
		for (Person p : personService.getPersons()) {
			System.out.println(p.getId()+":"+p.getName());
		}
	}
}
