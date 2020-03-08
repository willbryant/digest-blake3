#include <ruby.h>
#include <ruby/digest.h>
#include "blake3.h"

int blake3_init(void *ctx) {
	blake3_hasher_init((blake3_hasher *)ctx);
	return 1;
}

int blake3_finish(void *ctx, unsigned char *out) {
	blake3_hasher_finalize((blake3_hasher *)ctx, out, BLAKE3_OUT_LEN);
	return 1;
}

static const rb_digest_metadata_t blake3 = {
	RUBY_DIGEST_API_VERSION,
	BLAKE3_OUT_LEN,
	BLAKE3_BLOCK_LEN,
	sizeof(blake3_hasher),
	(rb_digest_hash_init_func_t)blake3_init,
	(rb_digest_hash_update_func_t)blake3_hasher_update,
	(rb_digest_hash_finish_func_t)blake3_finish,
};

void Init_blake3(void) {
	VALUE mDigest, cDigest_Base, cDigest_BLAKE3;

	rb_require("digest");

	mDigest = rb_path2class("Digest");
	cDigest_Base = rb_path2class("Digest::Base");
	cDigest_BLAKE3 = rb_define_class_under(mDigest, "BLAKE3", cDigest_Base);

#undef RUBY_UNTYPED_DATA_WARNING
#define RUBY_UNTYPED_DATA_WARNING 0
	rb_iv_set(cDigest_BLAKE3, "metadata",
		Data_Wrap_Struct(0, 0, 0, (void *)&blake3));
}
