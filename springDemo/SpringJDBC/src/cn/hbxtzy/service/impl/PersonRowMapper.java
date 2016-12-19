package cn.hbxtzy.service.impl;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import cn.hbxtzy.bean.Person;

public class PersonRowMapper implements RowMapper<Person> {

	@Override
	public Person mapRow(ResultSet rs, int index) throws SQLException {
		Person person = new Person();
		person.setId(rs.getInt(1));
		person.setName(rs.getString(2));
		return person;
	}

}
