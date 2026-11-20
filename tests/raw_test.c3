module yyjson_test @test;

import yyjson;

fn void read_matches_raw_binding()
{
	String json = `{"a":1}`;
	Doc doc     = yyjson::yyjson_read_opts(json.ptr, json.len, yyjson::READ_NOFLAG, null, null);
	assert(doc != null);
	assert(doc.root().is_obj());
	doc.free();
}

fn void raw_read_reports_error()
{
	String json = `{"a":}`;
	ReadErr err;
	Doc doc     = yyjson::yyjson_read_opts(json.ptr, json.len, yyjson::READ_NOFLAG, null, &err);
	assert(doc == null);
	assert(err.code != 0);
	assert(err.msg != null);
	assert(err.pos == 5);
}

fn void mut_doc_matches_raw_binding()
{
	MutDoc doc = yyjson::yyjson_mut_doc_new(null);
	assert(doc != null);
	yyjson::yyjson_mut_doc_free(doc);
}