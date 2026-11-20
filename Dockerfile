# syntax=docker/dockerfile:1.7

ARG WOLFI_BASE=cgr.dev/chainguard/wolfi-base:latest
ARG STATIC_IMAGE=cgr.dev/chainguard/static:latest

FROM ${WOLFI_BASE} AS build

ARG TARGETARCH

RUN apk add --no-cache build-base

WORKDIR /src

COPY 3rd ./3rd
COPY yyjson.c3i yyjson.c3 LICENSE ./

RUN gcc -O2 -fPIC -I3rd -c 3rd/yyjson.c -o yyjson.o \
    && gcc -O2 -fPIC -I3rd -c 3rd/yyjsonshim.c -o yyjsonshim.o \
    && ar rcs libyyjson.a yyjson.o yyjsonshim.o

RUN printf '%s\n' \
        '#include <string.h>' \
        '#include <stdlib.h>' \
        '#include <yyjsonshim.h>' \
        'int main(void) {' \
        '  char in[] = "{\"a\":1}";' \
        '  yyjson_doc *doc = yyjson_read_opts(in, strlen(in), 0, NULL, NULL);' \
        '  if (!doc || yyjsonshim_get_type(yyjsonshim_doc_get_root(doc)) != YYJSON_TYPE_OBJ) return 1;' \
        '  yyjsonshim_doc_free(doc);' \
        '  yyjson_mut_doc *mut = yyjson_mut_doc_new(NULL);' \
        '  yyjson_mut_val *root = yyjsonshim_mut_obj(mut);' \
        '  yyjsonshim_mut_doc_set_root(mut, root);' \
        '  yyjsonshim_mut_obj_add(root, yyjsonshim_mut_strncpy(mut, "n", 1), yyjsonshim_mut_sint(mut, 42));' \
        '  char *out = yyjson_mut_write_opts(mut, 0, NULL, NULL, NULL);' \
        '  int rc = !out || strcmp(out, "{\"n\":42}") != 0;' \
        '  free(out);' \
        '  yyjson_mut_doc_free(mut);' \
        '  return rc;' \
        '}' \
        > smoke.c \
    && gcc -I3rd smoke.c -L. -lyyjson -o smoke \
    && ./smoke

COPY <<'EOF' /src/manifest.json
{
  "provides": "yyjson",
  "version": "0.1.0",
  "authors": [ "Cristhian Gonzales Castillo <yo@gcca.dev>" ],
  "langrev": "1",
  "sources": [ "yyjson.c3i", "yyjson.c3" ],
  "targets": {
    "linux-x64": {
      "linked-libraries": [ "yyjson" ]
    },
    "linux-aarch64": {
      "linked-libraries": [ "yyjson" ]
    }
  }
}
EOF

RUN case "${TARGETARCH}" in \
        amd64) c3_target=linux-x64 ;; \
        arm64) c3_target=linux-aarch64 ;; \
        *) echo "unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac \
    && lib=/out/usr/lib/c3/yyjson.c3l \
    && mkdir -p /out/usr/include "$lib/$c3_target" /out/usr/share/licenses/yyjson.c3l \
    && cp 3rd/yyjson.h 3rd/yyjsonshim.h /out/usr/include/ \
    && cp libyyjson.a /out/usr/lib/ \
    && cp manifest.json yyjson.c3i yyjson.c3 "$lib/" \
    && cp libyyjson.a "$lib/$c3_target/" \
    && cp LICENSE 3rd/LICENSE.yyjson /out/usr/share/licenses/yyjson.c3l/

FROM ${STATIC_IMAGE}

COPY --from=build /out/usr/ /usr/

LABEL org.opencontainers.image.title="yyjson.c3l" \
      org.opencontainers.image.description="C3 bindings for yyjson: headers, libyyjson.a and /usr/lib/c3/yyjson.c3l" \
      org.opencontainers.image.source="https://github.com/gcca/yyjson.c3l" \
      org.opencontainers.image.version="0.1.0" \
      org.opencontainers.image.licenses="AGPL-3.0-only AND MIT"
