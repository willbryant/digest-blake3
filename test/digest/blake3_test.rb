require "test_helper"
require "digest/blake3_test_vectors"

class Digest::BLAKE3Test < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Digest::BLAKE3::VERSION
  end

  def test_it_reproduces_standard_test_cases
    input_data = (0..250).to_a.pack("C*")
    input_data << input_data while input_data.length < 102400

    BLAKE3_TEST_VECTORS[:cases].each do |test_case|
      assert_equal test_case[:hash][0, 64], Digest::BLAKE3.hexdigest(input_data[0, test_case[:input_len]])
    end
  end

  def test_it_supports_incremental_updates
    input_data = (0..250).to_a.pack("C*")
    input_data << input_data while input_data.length < 102400

    BLAKE3_TEST_VECTORS[:cases].each do |test_case|
      data = input_data[0, test_case[:input_len]]
      hasher = Digest::BLAKE3.new
      while data.length > 0
        len = rand(data.length - 1) + 1
        hasher.update data[0, len]
        data = data[len..-1]
      end
      assert_equal test_case[:hash][0, 64], hasher.hexdigest
    end
  end

  def test_it_crunches_large_data
    input_data = " "*1024*1024
    start = Time.now.to_f
    hasher = Digest::BLAKE3.new
    1024.times do
      hasher.update(input_data)
    end
    hasher.digest
    elapsed = Time.now.to_f - start
    puts "#{'%0.2f' % (input_data.length/elapsed/1024)} MB/sec"
  end
end
