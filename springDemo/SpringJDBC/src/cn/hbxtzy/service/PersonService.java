package cn.hbxtzy.service;

import java.util.List;

import cn.hbxtzy.bean.Person;

public interface PersonService {
	/**
	 * ±£¥ÊPerson
	 * @param person
	 */
	public void save(Person person);
	
	public void update(Person person);
	
	public Person getPerson(Integer personId);
	
	public List<Person> getPersons();
	
	public void delete(Integer personId);
	
}
