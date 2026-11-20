#include "yyjsonshim.h"

void yyjsonshim_doc_free(yyjson_doc *doc) { yyjson_doc_free(doc); }

yyjson_val *yyjsonshim_doc_get_root(const yyjson_doc *doc) {
  return yyjson_doc_get_root(doc);
}

yyjson_type yyjsonshim_get_type(const yyjson_val *val) {
  return yyjson_get_type(val);
}

size_t yyjsonshim_get_len(const yyjson_val *val) { return yyjson_get_len(val); }

bool yyjsonshim_is_int(const yyjson_val *val) { return yyjson_is_int(val); }

bool yyjsonshim_get_bool(const yyjson_val *val) { return yyjson_get_bool(val); }

int64_t yyjsonshim_get_sint(const yyjson_val *val) {
  return yyjson_get_sint(val);
}

double yyjsonshim_get_num(const yyjson_val *val) { return yyjson_get_num(val); }

const char *yyjsonshim_get_str(const yyjson_val *val) {
  return yyjson_get_str(val);
}

yyjson_val *yyjsonshim_arr_get(const yyjson_val *arr, size_t idx) {
  return yyjson_arr_get(arr, idx);
}

yyjson_val *yyjsonshim_obj_getn(const yyjson_val *obj, const char *key,
                                size_t key_len) {
  return yyjson_obj_getn(obj, key, key_len);
}

void yyjsonshim_mut_doc_set_root(yyjson_mut_doc *doc, yyjson_mut_val *root) {
  yyjson_mut_doc_set_root(doc, root);
}

yyjson_mut_val *yyjsonshim_mut_null(yyjson_mut_doc *doc) {
  return yyjson_mut_null(doc);
}

yyjson_mut_val *yyjsonshim_mut_bool(yyjson_mut_doc *doc, bool val) {
  return yyjson_mut_bool(doc, val);
}

yyjson_mut_val *yyjsonshim_mut_sint(yyjson_mut_doc *doc, int64_t num) {
  return yyjson_mut_sint(doc, num);
}

yyjson_mut_val *yyjsonshim_mut_real(yyjson_mut_doc *doc, double num) {
  return yyjson_mut_real(doc, num);
}

yyjson_mut_val *yyjsonshim_mut_strncpy(yyjson_mut_doc *doc, const char *str,
                                       size_t len) {
  return yyjson_mut_strncpy(doc, str, len);
}

yyjson_mut_val *yyjsonshim_mut_arr(yyjson_mut_doc *doc) {
  return yyjson_mut_arr(doc);
}

yyjson_mut_val *yyjsonshim_mut_obj(yyjson_mut_doc *doc) {
  return yyjson_mut_obj(doc);
}

bool yyjsonshim_mut_arr_append(yyjson_mut_val *arr, yyjson_mut_val *val) {
  return yyjson_mut_arr_append(arr, val);
}

bool yyjsonshim_mut_obj_add(yyjson_mut_val *obj, yyjson_mut_val *key,
                            yyjson_mut_val *val) {
  return yyjson_mut_obj_add(obj, key, val);
}
