require_relative 'path/router'

use Rack::CommonLogger
use Rack::Lint
use Rack::Static, urls: %w[/images /js /css], root: 'public'

run Router.new

__END__
# use Rack::ShowExceptions
