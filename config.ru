#!/usr/bin/env ruby
# Id$ nonnax 2022-03-23 12:38:55 +0800

require_relative 'lib/router'

use Rack::CommonLogger
use Rack::Lint
use Rack::Static, urls: %w[/images /js /css], root: 'public'

run Router.new

__END__
# use Rack::ShowExceptions
