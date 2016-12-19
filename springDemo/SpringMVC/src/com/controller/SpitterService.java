package com.controller;

import java.util.ArrayList;
import java.util.List;

public class SpitterService {

	public List<Spittle> getRecentSpittles(int defaultSpittersPerPage) {
		List<Spittle> spittles = new ArrayList<Spittle>();
		spittles.add(new Spittle("hs","hello world!"));
		spittles.add(new Spittle("hs2","hello world2!"));
		spittles.add(new Spittle("hs3","hello world3!"));
		return spittles;
	}
	
}
