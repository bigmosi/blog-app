# Author:: Couchbase <info@couchbase.com>
# Copyright:: 2011, 2012 Couchbase, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require File.join(File.dirname(__FILE__), 'setup')

class TestGet < MiniTest::Unit::TestCase

  def setup
    @mock = start_mock
  end

  def teardown
    stop_mock(@mock)
  end

  def test_trivial_get
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)
    connection.set(uniq_id, "bar")
    val = connection.get(uniq_id)
    assert_equal "bar", val
  end

  def test_extended_get
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)

    orig_cas = connection.set(uniq_id, "bar")
    val, flags, cas = connection.get(uniq_id, :extended => true)
    assert_equal "bar", val
    assert_equal 0x0, flags
    assert_equal orig_cas, cas

    orig_cas = connection.set(uniq_id, "bar", :flags => 0x1000)
    val, flags, cas = connection.get(uniq_id, :extended => true)
    assert_equal "bar", val
    assert_equal 0x1000, flags
    assert_equal orig_cas, cas
  end

  def test_multi_get
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)

    connection.set(uniq_id(1), "foo1")
    connection.set(uniq_id(2), "foo2")

    val1, val2 = connection.get(uniq_id(1), uniq_id(2))
    assert_equal "foo1", val1
    assert_equal "foo2", val2
  end

  def test_multi_get_extended
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)

    cas1 = connection.set(uniq_id(1), "foo1")
    cas2 = connection.set(uniq_id(2), "foo2")

    results = connection.get(uniq_id(1), uniq_id(2), :extended => true)
    assert_equal ["foo1", 0x0, cas1], results[uniq_id(1)]
    assert_equal ["foo2", 0x0, cas2], results[uniq_id(2)]
  end

  def test_multi_get_and_touch
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)
    connection.set(uniq_id(1), "foo1")
    connection.set(uniq_id(2), "foo2")

    results = connection.get(uniq_id(1) => 1, uniq_id(2) => 1)
    assert results.is_a?(Hash)
    assert_equal "foo1", results[uniq_id(1)]
    assert_equal "foo2", results[uniq_id(2)]
    sleep(2)
    assert_raises(Couchbase::Error::NotFound) do
      connection.get(uniq_id(1), uniq_id(2))
    end
    assert connection.get(uniq_id(1), uniq_id(2), :quiet => true).compact.empty?
  end

  def test_multi_get_and_touch_extended
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)

    cas1 = connection.set(uniq_id(1), "foo1")
    cas2 = connection.set(uniq_id(2), "foo2")

    results = connection.get({uniq_id(1) => 1, uniq_id(2) => 1}, :extended => true)
    assert_equal ["foo1", 0x0, cas1], results[uniq_id(1)]
    assert_equal ["foo2", 0x0, cas2], results[uniq_id(2)]
  end

  def test_multi_get_and_touch_with_single_key
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)
    connection.set(uniq_id, "foo1")

    results = connection.get(uniq_id => 1)
    assert results.is_a?(Hash)
    assert_equal "foo1", results[uniq_id]
    sleep(2)
    assert_raises(Couchbase::Error::NotFound) do
      connection.get(uniq_id)
    end
  end

  def test_missing_in_quiet_mode
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port, :quiet => true)
    cas1 = connection.set(uniq_id(1), "foo1")
    cas2 = connection.set(uniq_id(2), "foo2")

    val = connection.get(uniq_id(:missing))
    refute(val)
    val = connection.get(uniq_id(:missing), :extended => true)
    refute(val)

    val1, missing, val2  = connection.get(uniq_id(1), uniq_id(:missing), uniq_id(2))
    assert_equal "foo1", val1
    refute missing
    assert_equal "foo2", val2

    results = connection.get(uniq_id(1), uniq_id(:missing), uniq_id(2), :extended => true)
    assert_equal ["foo1", 0x0, cas1], results[uniq_id(1)]
    refute results[uniq_id(:missing)]
    assert_equal ["foo2", 0x0, cas2], results[uniq_id(2)]
  end

  def test_it_allows_temporary_quiet_flag
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port, :quiet => false)
    assert_raises(Couchbase::Error::NotFound) do
      connection.get(uniq_id(:missing))
    end
    refute connection.get(uniq_id(:missing), :quiet => true)
  end

  def test_missing_in_verbose_mode
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port, :quiet => false)
    connection.set(uniq_id(1), "foo1")
    connection.set(uniq_id(2), "foo2")

    assert_raises(Couchbase::Error::NotFound) do
      connection.get(uniq_id(:missing))
    end

    assert_raises(Couchbase::Error::NotFound) do
      connection.get(uniq_id(:missing), :extended => true)
    end

    assert_raises(Couchbase::Error::NotFound) do
      connection.get(uniq_id(1), uniq_id(:missing), uniq_id(2))
    end

    assert_raises(Couchbase::Error::NotFound) do
      connection.get(uniq_id(1), uniq_id(:missing), uniq_id(2), :extended => true)
    end
  end

  def test_asynchronous_get
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)
    cas = connection.set(uniq_id, "foo", :flags => 0x6660)
    res = []

    suite = lambda do |conn|
      res.clear
      conn.get(uniq_id) # ignore result
      conn.get(uniq_id) {|ret| res << ret}
      handler = lambda {|ret| res << ret}
      conn.get(uniq_id, &handler)
    end

    checks = lambda do
      res.each do |r|
        assert r.is_a?(Couchbase::Result)
        assert r.success?
        assert_equal uniq_id, r.key
        assert_equal "foo", r.value
        assert_equal 0x6660, r.flags
        assert_equal cas, r.cas
      end
    end

    connection.run(&suite)
    checks.call

    connection.run{ suite.call(connection) }
    checks.call
  end

  def test_asynchronous_multi_get
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)
    connection.set(uniq_id(1), "foo")
    connection.set(uniq_id(2), "bar")

    res = {}
    connection.run do |conn|
      conn.get(uniq_id(1), uniq_id(2)) {|ret| res[ret.key] = ret.value}
    end

    assert res[uniq_id(1)]
    assert_equal "foo", res[uniq_id(1)]
    assert res[uniq_id(2)]
    assert_equal "bar", res[uniq_id(2)]
  end

  def test_asynchronous_get_missing
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)
    connection.set(uniq_id, "foo")
    res = {}
    missing = []

    get_handler = lambda do |ret|
      assert_equal :get, ret.operation
      if ret.success?
        res[ret.key] = ret.value
      else
        if ret.error.is_a?(Couchbase::Error::NotFound)
          missing << ret.key
        else
          raise ret.error
        end
      end
    end

    suite = lambda do |conn|
      res.clear
      missing.clear
      conn.get(uniq_id(:missing1), &get_handler)
      conn.get(uniq_id, uniq_id(:missing2), &get_handler)
    end

    connection.run(&suite)
    refute res.has_key?(uniq_id(:missing1))
    refute res.has_key?(uniq_id(:missing2))
    assert_equal [uniq_id(:missing1), uniq_id(:missing2)], missing.sort
    assert_equal "foo", res[uniq_id]

    connection.quiet = true
    connection.run(&suite)
    assert_equal "foo", res[uniq_id]
    assert res.has_key?(uniq_id(:missing1)) # handler was called with nil
    refute res[uniq_id(:missing1)]
    assert res.has_key?(uniq_id(:missing2))
    refute res[uniq_id(:missing2)]
    assert_empty missing
  end

  def test_get_using_brackets
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)

    orig_cas = connection.set(uniq_id, "foo", :flags => 0x1100)

    val = connection[uniq_id]
    assert_equal "foo", val

    if RUBY_VERSION =~ /^1\.9/
      eval <<-EOC
      val, flags, cas = connection[uniq_id, :extended => true]
      assert_equal "foo", val
      assert_equal 0x1100, flags
      assert_equal orig_cas, cas
      EOC
    end
  end

  def test_it_allows_to_store_nil
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)

    orig_cas = connection.set(uniq_id, nil)
    assert orig_cas.is_a?(Numeric)

    refute connection.get(uniq_id)
    # doesn't raise NotFound exception
    refute connection.get(uniq_id, :quiet => false)
    # returns CAS
    value, flags, cas = connection.get(uniq_id, :extended => true)
    refute value
    assert_equal 0x00, flags
    assert_equal orig_cas, cas
  end

  def test_zero_length_string_is_not_nil
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)

    connection.set(uniq_id, "", :format => :document)
    assert_equal "", connection.get(uniq_id)

    connection.set(uniq_id, "", :format => :plain)
    assert_equal "", connection.get(uniq_id)

    connection.set(uniq_id, "", :format => :marshal)
    assert_equal "", connection.get(uniq_id)

    connection.set(uniq_id, nil, :format => :document)
    assert_equal nil, connection.get(uniq_id, :quiet => false)

    assert_raises Couchbase::Error::ValueFormat do
      connection.set(uniq_id, nil, :format => :plain)
    end

    connection.set(uniq_id, nil, :format => :marshal)
    assert_equal nil, connection.get(uniq_id, :quiet => false)
  end

  def test_format_forcing
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)

    connection.set(uniq_id, '{"foo":"bar"}', :format => :plain)
    value, flags, _ = connection.get(uniq_id, :extended => true)
    assert_equal '{"foo":"bar"}', value
    assert_equal 0x02, flags

    value, flags, _ = connection.get(uniq_id, :extended => true, :format => :document)
    expected = {"foo" => "bar"}
    assert_equal expected, value
    assert_equal 0x02, flags

    connection.prepend(uniq_id, "NOT-A-JSON")
    assert_raises Couchbase::Error::ValueFormat do
      connection.get(uniq_id, :format => :document)
    end
  end

  # http://www.couchbase.com/issues/browse/RCBC-31
  def test_consistent_behaviour_for_arrays
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)

    cas = connection.set(uniq_id("foo"), "foo")
    connection.set(uniq_id("bar"), "bar")

    assert_equal "foo", connection.get(uniq_id("foo"))
    assert_equal ["foo"], connection.get([uniq_id("foo")])
    assert_equal ["foo", "bar"], connection.get([uniq_id("foo"), uniq_id("bar")])
    assert_equal ["foo", "bar"], connection.get(uniq_id("foo"), uniq_id("bar"))
    expected = {uniq_id("foo") => ["foo", 0x00, cas]}
    assert_equal expected, connection.get([uniq_id("foo")], :extended => true)
    assert_raises TypeError do
      connection.get([uniq_id("foo"), uniq_id("bar")], [uniq_id("foo")])
    end
  end

  def test_get_with_lock_trivial
    if @mock.real?
      connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)
      connection.set(uniq_id, "foo")
      assert_equal "foo", connection.get(uniq_id, :lock => 1)
      assert_raises Couchbase::Error::KeyExists do
        connection.set(uniq_id, "bar")
      end
      sleep(2)
      connection.set(uniq_id, "bar")
    else
      skip("implement GETL in CouchbaseMock.jar")
    end
  end

  def test_multi_get_with_lock
    if @mock.real?
      connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)
      connection.set(uniq_id(1), "foo1")
      connection.set(uniq_id(2), "foo2")
      assert_equal ["foo1", "foo2"], connection.get([uniq_id(1), uniq_id(2)], :lock => 1)
      assert_raises Couchbase::Error::KeyExists do
        connection.set(uniq_id(1), "bar")
      end
      assert_raises Couchbase::Error::KeyExists do
        connection.set(uniq_id(2), "bar")
      end
    else
      skip("implement GETL in CouchbaseMock.jar")
    end
  end

  def test_multi_get_with_custom_locks
    if @mock.real?
      connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)
      connection.set(uniq_id(1), "foo1")
      connection.set(uniq_id(2), "foo2")
      expected = {uniq_id(1) => "foo1", uniq_id(2) => "foo2"}
      assert_equal expected, connection.get({uniq_id(1) => 1, uniq_id(2) => 2}, :lock => true)
      assert_raises Couchbase::Error::KeyExists do
        connection.set(uniq_id(1), "foo")
      end
      assert_raises Couchbase::Error::KeyExists do
        connection.set(uniq_id(2), "foo")
      end
    else
      skip("implement GETL in CouchbaseMock.jar")
    end
  end

  def test_multi_get_result_hash_assembling
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)
    connection.set(uniq_id(1), "foo")
    connection.set(uniq_id(2), "bar")

    expected = {uniq_id(1) => "foo", uniq_id(2) => "bar"}
    assert_equal expected, connection.get(uniq_id(1), uniq_id(2), :assemble_hash => true)
  end
end
