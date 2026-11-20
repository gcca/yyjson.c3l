#pragma once

#include "yyjson.h"

#ifdef __cplusplus
extern "C" {
#endif

void yyjsonshim_doc_free(yyjson_doc *doc);
yyjson_val *yyjsonshim_doc_get_root(const yyjson_doc *doc);

yyjson_type yyjsonshim_get_type(const yyjson_val *val);
size_t yyjsonshim_get_len(const yyjson_val *val);
bool yyjsonshim_is_int(const yyjson_val *val);
bool yyjsonshim_get_bool(const yyjson_val *val);
int64_t yyjsonshim_get_sint(const yyjson_val *val);
double yyjsonshim_get_num(const yyjson_val *val);
const char *yyjsonshim_get_str(const yyjson_val *val);
yyjson_val *yyjsonshim_arr_get(const yyjson_val *arr, size_t idx);
yyjson_val *yyjsonshim_obj_getn(const yyjson_val *obj, const char *key,
                                size_t key_len);

void yyjsonshim_mut_doc_set_root(yyjson_mut_doc *doc, yyjson_mut_val *root);
yyjson_mut_val *yyjsonshim_mut_null(yyjson_mut_doc *doc);
yyjson_mut_val *yyjsonshim_mut_bool(yyjson_mut_doc *doc, bool val);
yyjson_mut_val *yyjsonshim_mut_sint(yyjson_mut_doc *doc, int64_t num);
yyjson_mut_val *yyjsonshim_mut_real(yyjson_mut_doc *doc, double num);
yyjson_mut_val *yyjsonshim_mut_strncpy(yyjson_mut_doc *doc, const char *str,
                                       size_t len);
yyjson_mut_val *yyjsonshim_mut_arr(yyjson_mut_doc *doc);
yyjson_mut_val *yyjsonshim_mut_obj(yyjson_mut_doc *doc);
bool yyjsonshim_mut_arr_append(yyjson_mut_val *arr, yyjson_mut_val *val);
bool yyjsonshim_mut_obj_add(yyjson_mut_val *obj, yyjson_mut_val *key,
                            yyjson_mut_val *val);

#ifdef __cplusplus
}
#endif
