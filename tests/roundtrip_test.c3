module yyjson_test @test;

import yyjson;

fn void write_then_read()
{
	MutDoc out = yyjson::mut_doc()!!;
	defer out.free();
	MutVal root = out.new_obj();
	out.set_root(root);
	assert(out.add(root, "kind", out.new_str("cat")));
	assert(out.add(root, "lives", out.new_int(9)));
	String json = out.write()!!;
	defer yyjson::free(json);

	Doc doc = yyjson::read(json)!!;
	defer doc.free();
	assert(doc.root().get("kind")!!.get_str()!! == "cat");
	assert(doc.root().get("lives")!!.get_int()!! == 9);
}

fn void read_then_write_minifies()
{
	Doc doc = yyjson::read(`{ "a" : [ 1 , 2 ] , "b" : "c" }`)!!;
	defer doc.free();
	String json = doc.write()!!;
	defer yyjson::free(json);
	assert(json == `{"a":[1,2],"b":"c"}`);
}