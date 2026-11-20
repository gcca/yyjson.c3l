module yyjson_test @test;

import yyjson;

fn void read_object_fields()
{
	Doc doc = yyjson::read(`{"name":"Mash","star":4,"rate":4.5,"ok":true,"none":null}`)!!;
	defer doc.free();
	Val root = doc.root();
	assert(root.is_obj());
	assert(root.len() == 5);
	assert(root.get("name")!!.get_str()!! == "Mash");
	assert(root.get("star")!!.get_int()!! == 4);
	assert(root.get("rate")!!.get_num()!! == 4.5);
	assert(root.get("star")!!.get_num()!! == 4.0);
	assert(root.get("ok")!!.get_bool()!!);
	assert(root.get("none")!!.is_null());
}

fn void read_missing_key_is_not_found()
{
	Doc doc = yyjson::read(`{"name":"Mash"}`)!!;
	defer doc.free();
	Val? absent = doc.root().get("absent");
	assert(@catch(absent) == yyjson::NOT_FOUND);
}

fn void read_wrong_type_is_type_mismatch()
{
	Doc doc = yyjson::read(`{"star":4,"name":"Mash"}`)!!;
	defer doc.free();
	Val root = doc.root();
	assert(@catch(root.get("star")!!.get_str()) == yyjson::TYPE_MISMATCH);
	assert(@catch(root.get("name")!!.get_int()) == yyjson::TYPE_MISMATCH);
	assert(@catch(root.get("name")!!.get_num()) == yyjson::TYPE_MISMATCH);
	assert(@catch(root.get("name")!!.get_bool()) == yyjson::TYPE_MISMATCH);
}

fn void read_array_elements()
{
	Doc doc = yyjson::read(`[2,"x",[1]]`)!!;
	defer doc.free();
	Val root = doc.root();
	assert(root.is_arr());
	assert(root.len() == 3);
	assert(root.at(0)!!.get_int()!! == 2);
	assert(root.at(1)!!.get_str()!! == "x");
	assert(root.at(2)!!.is_arr());
	assert(@catch(root.at(3)) == yyjson::NOT_FOUND);
}

fn void read_string_with_embedded_nul()
{
	Doc doc = yyjson::read(`"a\u0000b"`)!!;
	defer doc.free();
	assert(doc.root().get_str()!!.len == 3);
}

fn void read_invalid_json_fails()
{
	Doc? doc = yyjson::read("{ this is not json");
	assert(@catch(doc) == yyjson::PARSE_FAILED);
}

fn void read_flags_are_passed()
{
	assert(@catch(yyjson::read(`[1,2,]`)) == yyjson::PARSE_FAILED);
	Doc doc = yyjson::read(`[1,2,]`, yyjson::READ_ALLOW_TRAILING_COMMAS)!!;
	defer doc.free();
	assert(doc.root().len() == 2);
}

fn void read_ignores_insitu()
{
	Doc doc = yyjson::read(`{"a":"b"}`, yyjson::READ_INSITU)!!;
	defer doc.free();
	assert(doc.root().get("a")!!.get_str()!! == "b");
}