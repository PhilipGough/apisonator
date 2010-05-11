$:.unshift(::File.join(::File.dirname(__FILE__), 'lib'))

require 'rubygems'
require 'rack/fiber_pool'
require '3scale/backend'

use Rack::FiberPool
run ThreeScale::Backend::Application
