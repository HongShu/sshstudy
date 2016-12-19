package com.controller;

public class Spittle {
	private String id;
	private  String message;
	public Spittle(String id, String message) {
		super();
		this.id = id;
		this.message = message;
	}
	public Spittle() {
		super();
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	

}
