require 'dart/railtie'
require 'dart/sprockets/dart2js_compiler'

module Dart
  case Sprockets::VERSION
    when /^2/
      Sprockets.register_engine '.dart2js', Dart2JsCompiler
    when /^3/
      Sprockets.register_mime_type 'application/dart', extensions: ['.dart']
      Sprockets.register_transformer 'application/dart', 'application/javascript', Dart2JsCompiler
  end
end
