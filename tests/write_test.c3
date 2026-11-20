module yyjson_test @test;

import yyjson;

fn void write_readme_example()
{
	MutDoc doc = yyjson::mut_doc()!!;
	defer doc.free();
	MutVal root = doc.new_obj();
	doc.set_root(root);
	assert(doc.add(root, "name", doc.new_str("Mash")));
	assert(doc.add(root, "star", doc.new_int(4)));
	MutVal hits = doc.new_arr();
	foreach (hit : (int[]) { 2, 2, 1, 3 }) assert(doc.append(hits, doc.new_int(hit)));
	assert(doc.add(root, "hits", hits));
	String json = doc.write()!!;
	defer yyjson::free(json);
	assert(json == `{"name":"Mash","star":4,"hits":[2,2,1,3]}`);
}

fn void write_scalars()
{
	MutDoc doc = yyjson::mut_doc()!!;
	defer doc.free();
	MutVal root = doc.new_arr();
	doc.set_root(root);
	assert(doc.append(root, doc.new_null()));
	assert(doc.append(root, doc.new_bool(true)));
	assert(doc.append(root, doc.new_real(1.5)));
	assert(doc.append(root, doc.new_int(-7)));
	String json = doc.write()!!;
	defer yyjson::free(json);
	assert(json == `[null,true,1.5,-7]`);
}

fn void write_pretty_is_larger()
{
	MutDoc doc = yyjson::mut_doc()!!;
	defer doc.free();
	MutVal root = doc.new_obj();
	doc.set_root(root);
	assert(doc.add(root, "name", doc.new_str("Mash")));
	String minified = doc.write()!!;
	defer yyjson::free(minified);
	String pretty = doc.write(yyjson::WRITE_PRETTY)!!;
	defer yyjson::free(pretty);
	assert(pretty.len > minified.len);
}

fn void write_copies_strings()
{
	MutDoc doc = yyjson::mut_doc()!!;
	defer doc.free();
	MutVal root = doc.new_obj();
	doc.set_root(root);
	char[3] key   = { 'k', 'e', 'y' };
	char[3] value = { 'v', 'a', 'l' };
	assert(doc.add(root, (String)key[..], doc.new_str((String)value[..])));
	key[..] = 'x';
	value[..] = 'y';
	String json = doc.write()!!;
	defer yyjson::free(json);
	assert(json == `{"key":"val"}`);
}

fn void write_empty_doc_fails()
{
	MutDoc doc = yyjson::mut_doc()!!;
	defer doc.free();
	assert(@catch(doc.write()) == yyjson::WRITE_FAILED);
}

fn void add_to_non_object_fails()
{
	MutDoc doc = yyjson::mut_doc()!!;
	defer doc.free();
	MutVal arr = doc.new_arr();
	assert(!doc.add(arr, "k", doc.new_null()));
	assert(!doc.append(doc.new_obj(), doc.new_null()));
}