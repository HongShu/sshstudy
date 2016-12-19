package cn.hbxtzy.service.impl;

import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;

import cn.hbxtzy.bean.Person;
import cn.hbxtzy.service.PersonService;

public class PersonServiceBean implements PersonService {
	private JdbcTemplate jdbcTemplate;

	public void setDataSource(DataSource dataSource) {
		jdbcTemplate = new JdbcTemplate(dataSource);
	}

	@Override
	public void delete(Integer personId) {
		jdbcTemplate
				.update("delete from a where id=?", new Object[] { personId },
						new int[] { java.sql.Types.INTEGER });
	}

	@Override
	public Person getPerson(Integer personId) {
		return jdbcTemplate.queryForObject("select * from a where id = ?",
				new Object[] { personId },
				new int[] { java.sql.Types.INTEGER }, new PersonRowMapper());
		
	}

	@Override
	public List<Person> getPersons() {
		
		return jdbcTemplate.query("select * from a", new PersonRowMapper());
	}

	@Override
	public void save(Person person) {
		jdbcTemplate.update("insert into a (name) values (?)",
				new Object[] { person.getName() },
				new int[] { java.sql.Types.VARBINARY });

	}

	@Override
	public void update(Person person) {
		jdbcTemplate.update(" update a set name =? where id=?", new Object[] {
				person.getName(), person.getId() }, new int[] {
				java.sql.Types.VARBINARY, java.sql.Types.INTEGER });

	}

}
