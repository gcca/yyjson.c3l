module yyjson;
import libc;

faultdef PARSE_FAILED, CREATE_FAILED, WRITE_FAILED, NOT_FOUND, TYPE_MISMATCH;

fn Doc? read(String json, ReadFlag flags = READ_NOFLAG)
{
	Doc doc = yyjson_read_opts(json.ptr, json.len, flags & ~READ_INSITU, null, null);
	if (!doc) return PARSE_FAILED~;
	return doc;
}

fn void free(String json) => libc::free(json.ptr);

extern fn void Doc.free(self) @cname("yyjsonshim_doc_free");

extern fn Val Doc.root(self) @cname("yyjsonshim_doc_get_root");

fn String? Doc.write(self, WriteFlag flags = WRITE_NOFLAG)
{
	usz len;
	char* json = yyjson_write_opts(self, flags, null, &len, null);
	if (!json) return WRITE_FAILED~;
	return (String)json[:len];
}

extern fn Type Val.type(self) @cname("yyjsonshim_get_type");

extern fn usz Val.len(self) @cname("yyjsonshim_get_len");

fn bool Val.is_null(self) => self.type() == NULL;

fn bool Val.is_bool(self) => self.type() == BOOL;

fn bool Val.is_num(self) => self.type() == NUM;

fn bool Val.is_str(self) => self.type() == STR;

fn bool Val.is_arr(self) => self.type() == ARR;

fn bool Val.is_obj(self) => self.type() == OBJ;

fn Val? found(Val val) @local
{
	if (!val) return NOT_FOUND~;
	return val;
}

fn Val? Val.get(self, String key) => found(yyjsonshim_obj_getn(self, key.ptr, key.len));

fn Val? Val.at(self, usz index) => found(yyjsonshim_arr_get(self, index));

fn String? Val.get_str(self)
{
	char* s = yyjsonshim_get_str(self);
	if (!s) return TYPE_MISMATCH~;
	return (String)s[:self.len()];
}

fn long? Val.get_int(self)
{
	if (!yyjsonshim_is_int(self)) return TYPE_MISMATCH~;
	return yyjsonshim_get_sint(self);
}

fn double? Val.get_num(self)
{
	if (!self.is_num()) return TYPE_MISMATCH~;
	return yyjsonshim_get_num(self);
}

fn bool? Val.get_bool(self)
{
	if (!self.is_bool()) return TYPE_MISMATCH~;
	return yyjsonshim_get_bool(self);
}

fn MutDoc? mut_doc()
{
	MutDoc doc = yyjson_mut_doc_new(null);
	if (!doc) return CREATE_FAILED~;
	return doc;
}

extern fn void MutDoc.free(self) @cname("yyjson_mut_doc_free");

extern fn void MutDoc.set_root(self, MutVal root) @cname("yyjsonshim_mut_doc_set_root");

extern fn MutVal MutDoc.new_null(self) @cname("yyjsonshim_mut_null");

extern fn MutVal MutDoc.new_bool(self, bool val) @cname("yyjsonshim_mut_bool");

extern fn MutVal MutDoc.new_int(self, long num) @cname("yyjsonshim_mut_sint");

extern fn MutVal MutDoc.new_real(self, double num) @cname("yyjsonshim_mut_real");

fn MutVal MutDoc.new_str(self, String s) => yyjsonshim_mut_strncpy(self, s.ptr, s.len);

extern fn MutVal MutDoc.new_arr(self) @cname("yyjsonshim_mut_arr");

extern fn MutVal MutDoc.new_obj(self) @cname("yyjsonshim_mut_obj");

fn bool MutDoc.add(self, MutVal obj, String key, MutVal val) => yyjsonshim_mut_obj_add(obj, self.new_str(key), val);

fn bool MutDoc.append(self, MutVal arr, MutVal val) => yyjsonshim_mut_arr_append(arr, val);

fn String? MutDoc.write(self, WriteFlag flags = WRITE_NOFLAG)
{
	usz len;
	char* json = yyjson_mut_write_opts(self, flags, null, &len, null);
	if (!json) return WRITE_FAILED~;
	return (String)json[:len];
}