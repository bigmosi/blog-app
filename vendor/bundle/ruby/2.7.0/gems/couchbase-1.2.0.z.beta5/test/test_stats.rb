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

class TestStats < MiniTest::Unit::TestCase

  def setup
    @mock = start_mock(:num_nodes => 4)
  end

  def teardown
    stop_mock(@mock)
  end

  def test_trivial_stats_without_argument
    connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)
    stats = connection.stats
    assert stats.is_a?(Hash)
    assert stats.has_key?("pid")
    key, info = stats.first
    assert key.is_a?(String)
    assert info.is_a?(Hash)
    assert_equal @mock.num_nodes, info.size
  end

  def test_stats_with_argument
    if @mock.real?
      connection = Couchbase.new(:hostname => @mock.host, :port => @mock.port)
      stats = connection.stats("memory")
      assert stats.is_a?(Hash)
      assert stats.has_key?("mem_used")
      key, info = stats.first
      assert key.is_a?(String)
      assert info.is_a?(Hash)
      assert_equal @mock.num_nodes, info.size
    else
      # FIXME
      skip("make CouchbaseMock.jar STATS more real-life")
    end
  end

end
