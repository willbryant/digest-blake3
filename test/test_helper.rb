$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift File.expand_path("../../ext", __FILE__)
require "digest/blake3"

require "minitest/autorun"
