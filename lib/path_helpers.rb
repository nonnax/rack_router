#!/usr/bin/env ruby
# Id$ nonnax 2022-03-27 17:56:41 +0800
module PathHelpers
  def compile_path_params(path)
      extra_params = []
      compiled_path = path.gsub(/:\w+/) do |match|
        extra_params << match.gsub(':', '').to_sym
        '([^/?#]+)'
      end
      [/^#{compiled_path}$/, extra_params]
  end
end
