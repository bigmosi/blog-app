## 1.2.0.z.beta5 / 2012-11-29

* Reduce probability name conflict: use "cb_" prefix
* Fix function prefixes
* Make error message about dependency more verbose
* Allow to setup default initial value for INCR/DECR
* Fix memory leaks: in async mode context wasn't freed
* RCBC-95 Use response body to clarify Couchbase::Error::HTTP

## 1.2.0.z.beta4 / 2012-11-21

* Do not hide ValueFormat reason
* Adjust version check for MultiJson monkeypatch
* Update error codes
* Remove mentions of LCB_LIBEVENT_ERROR in utils.c
* Add Makefile for easier build with repo layout
* Check HTTP error code when building exception object
* Remove debug output in tests
* Make rack session store adapter quiet
* RCBC-90 Update documentation about session store
* Protect against non string values in :plain mode
* RCBC-89 Fetch documents using binary protocol by default
* Deserialize Base64 value from view
* Remove all_docs mentions
* RCBC-92 Use more portable version of rb_sprintf()
* Do not expose docs embedded in HTTP response
* RCBC-94 Reset global exception after usage
* Fix number of arguments to Kernel#sprintf
* Increase default connection timeout

## 1.2.0.z.beta3 / 2012-10-12

* Update view API
* Mention couchbase-model and em-couchbase in README
* Use global scope to find Error classes (thanks to @wr0ngway)
* RCBC-87 Fix build error on macos
* Use lcb_breakout()
* Propogate status code for HTTP responses
* Extract params encoding for easier reusage
* Destory IO operations struct (fix memleak)
* Don't try to convert error to number, it is exception object
* Update error codes
* Implement bucket create/delete operations
* Fixup FLUSH tests

## 1.2.0.z.beta2 / 2012-09-19

* RCBC-82 Fix extconf.rb for RVM/MacOS. (Not all rubies are fat on MacOS)

## 1.2.0.z.beta / 2012-09-18

* Fix version ordering by using ".z" prefix before .beta

## 1.2.0.beta / 2012-09-18

* RCBC-70 return binary keys using Encoding.external value (thanks to Alex Leverington)
* Create new key object only if it is necessary
* Switch to rbenv because RVM doesn't work with tclsh
* [backport] RCBC-37 Bootstrapping using multiple nodes
* React on HTTP level errors in view request
* Fix typo: check for MultiJson.decode
* Use unified HTTP function from the latest libcouchbase
* Expose HTTP headers
* Update views to meet latest server changes
* Add support for spatial views
* Use updated libcouchbase_cancel_http_request()
* Workaround query issue on group=false&reduce=false
* Update windows build
* Bump version 1.1.4
* Refactor the C extension
* Fix CAS conversion for Bucket#delete method for 32-bit systems
* RCBC-28 Implement Bucket#unlock
* CCBC-98 Expose client temporary failure error
* Fix warnings in doc generator and specify return values
* Fix -Wreturn-type warning
* Add attribute reader for Error::Base status code
* Unset RUBYOPT to avoid issues with bundler
* Ignore shared object on macos
* RCBC-79 Use RESTful flush
* Fix build under bundler on MacOS
* RCBC-81 Protect against NoMethodError
* Fixup MAKEFILE_CONFIG which is copy of the CONFIG
* RCBC-81 Protect against NoMethodError
* Update windows build

## 1.2.0.dp6 / 2012-07-28

* Inherit StandardError instead RuntimeError for errors
* Use renamed functions for view requests
* Depend on yard-xml plugin to dump docs into single XML
* No need to check for NULL before deallocating memory
* RCBC-37 Bootstrapping using multiple nodes
* More docs and examples on views (fixes RCBC-43)
* RCBC-40 Fix Bucket#cas operation behaviour in async mode
* RCBC-39 Allow to specify delta for incr/decr in options
* Update README
* Apply timeout value before connection
* Clarify connection exceptions
* Remove seqno kludge
* rb_hash_delete() function could incorrectly detect block presence
* Add example with in-URL credentials
* RCBC-57 Expose timers API from libcouchbase
* RCBC-50 Allow to read keys from replica
* RCBC-6 Implement OBSERVE command
* Expose number of replicas to the user
* Notify about observe batch finish in async mode
* Separate memory errors for client and server
* Prefix error message from views with "SERVER: "
* Remove timeout hack
* RCBC-49 Bucket#observe_and_wait primitive
* RCBC-47 Allow to skip username for protected buckets
* Use allocators instead of singleton methods
* Check RDATA()->dfree to ensure object type
* Fix observe_and_wait in async mode
* Fill 'operation' in observe_and_wait Result object
* Fix extraction Hash with keys in observe_and_wait
* RCBC-49 :observe option for storage functions
* Fix timeout test
* Mention couchbase.com in install errors
* Make Bucket#observe_and_wait more 1.8.7 friendly

## 1.2.0.dp5 / 2012-06-15

* Allow to force assembling result Hash for multi-get
* Fix documentation for :ttl option in Bucket#cas
* Implement key prefix (simple namespacing)
* Implement cache store adapter for Rails
* Integrate with Rack and Rails session store

## 1.2.0.dp4 / 2012-06-07

* RCBC-36 Fix segfault
* Comment out unpredictable test
* Update replace documentation: it accepts :cas option

## 1.2.0.dp3 / 2012-06-06

* Fix for multi_json < 1.3.3
* Break out from event loop for non-chunked responses (fix creating
  design create)

## 1.2.0.dp2 / 2012-06-05

* RCBC-31 Make Bucket#get more consistent
* Use monotonic high resolution clock
* Implement threshold for outgoing commands
* Allow to stop event loop from ruby
* RCBC-35 Fix the params escaping
* RCBC-34 Use multi_json gem
* Allow to block and wait for part of the requests
* Fix view iterator. It doesn't lock event loop anymore
* Specify HTTP method when body is set for View request
* Define views only if "views" key presented
* Use plain structs instead of typedefs
* Use debugger gem for 1.9.x rubies
* Use latest stable build of libcouchbase for travis-ci
* Require yajl as development dependency
* Implement get with lock operation
* Update docs

## 1.2.0.dp / 2012-04-06

* Properly handle hashes as Couchbase.connection_options
* Implement views
* Use verbose mode by default throwing exceptions on NOT_FOUND errors.
  This means that quiet attribute is false now on new connections.
* Doc fixes

## 1.1.4 / 2012-08-30

* RCBC-70 return binary keys using Encoding.external value (thanks to Alex Leverington)
* Switch to rbenv because RVM doesn't work with tclsh
* [backport] RCBC-37 Bootstrapping using multiple nodes

## 1.1.3 / 2012-07-27

* RCBC-59 Replicate flags in Bucket#cas operation
* calloc -> xcalloc, free -> xfree
* RCBC-64 Fix Couchbase::Bucket#dup
* Make object_space GC protector per-bucket object
* RCBC-60 Protect exceptions from GC

## 1.1.2 / 2012-06-05

* Upgrade libcouchbase dependency up to 1.0.4
* Backport debugger patch

## 1.1.1 / 2012-03-19

* Allow to force format for get operation (thanks to Darian Shimy)
* Use all arguments if receiver arity is -1 (couchbase_ext.c)
* Doc fixes

## 1.1.0 / 2012-03-07

* Timeout support (CCBC-20)
* Implement disconnect/reconnect interface
* Improve error handling code
* Use URI parser from stdlib
* Improve the documentation and the tests
* Remove direct dependency on libevent
* Remove sasl dependency
* Fix storing empty line and nil
* Allow running tests on real cluster
* Cross-build for windows
* Keep connections in thread local storage
* Add block execution time to timeout
* Implement VERSION command
* Configure Travis-CI

## 1.0.0 / 2011-12-23

* Implement all operations using libcouchbase as backend
* Remove views code. It will be re-added in 1.1 version

## 0.9.8 / 2011-12-16

* Fix RCBC-10: It was impossible to store data in non-default buckets

## 0.9.7 / 2011-10-04

* Fix design doc removing
* Fix 'set' method signature: add missing options argument
* Rename gem to 'couchbase' for easy of use. The github project still
  is 'couchbase-ruby-client'

## 0.9.6 / 2011-10-04

* Fix bug with decoding multiget result
* Allow create design documents from IO and String
* Rename json format to document, and describe possible formats
* Allow to handle errors in view result stream
* Remove dependency on libyajl library: it bundled with yaji now
* Update rake tasks: create zip- and tar-balls

## 0.9.5 / 2011-08-24

* Update installation notes in README

## 0.9.4 / 2011-08-24

* Use streaming json parser to iterate over view results
* Update memcached gem dependency to v1.3
* Proxy TOUCH command to memcached client
* Fix minor bugs in RestClient and Document classes
* Disable CouchDB API for nodes without 'couchApiBase' key provided.
* Fix bug with unicode parsing in config listener
* Add more unit tests

## 0.9.3 / 2011-07-29

* Use Latch (via Mutex and ConditionVariable) to wait until initial
  setup will be finished.
* Update prefix for development views (from '$dev_' to 'dev_')

## 0.9.2 / 2011-07-29

* Use zero TTL by default to store records forever
* Update documentation
* Sleep if setup isn't done

## 0.9.1 / 2011-07-25

* Minor bugfix for RestClient initialization

## 0.9.0 / 2011-07-25

* Initial public release
