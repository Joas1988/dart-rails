dart-rails
==========

### Changelog

v0.1.0 - 29. Aug. 2014:
  * Note that `.dart2js` templates are no longer needed. Sprockets
  DirectiveProcessor for Javascript ist now capable of including
  dart2js-compiled scripts via a `//= dart dart_app` directive. See
  updated sample application on github.
  * Errors during dart2js compilation will now be handled by Sprockets
  and thus the exception message will be thrown in the created js file.
  For now there will be also an output on the console.
  * As for newest SprocketsRails there is no longer the need of manually
  adding `dart.js` to the precompilation list.
  * Compiled scripts will reside in the `#{Rails.root}/tmp/cache/` directory.


### Idea

Handle [dart](https://www.dartlang.org/ 'dartlang.org') scripts so they get transcoded to js for browsers
without dart support. Currently there's only the `Dartium` browser from the development-kit that supports
dart directly.

For now this is a rather stupid attempt, although it works. 

For a working sample check [m0gg/dart-rails-sample](https://github.com/m0gg/dart-rails-sample 'm0gg/dart-rails-sample').

### Setup

  1. `Gemfile`

        ```rb
        gem 'ruby-dart', :git => 'https://github.com/m0gg/ruby-dart_js.git'
        gem 'dart-rails', :git => 'https://github.com/m0gg/dart-rails.git'
        ```

  2. run `rails generate dart:assets` this will bring you:

        ````sh
        $ rails g dart:assets
        create  app/assets/darts
        create  app/assets/darts/dart_app.dart
        create  app/assets/darts/dart_app.js.dart2js
        create  app/assets/darts/pubspec.yaml
        ```

  3. Currently you still need to add following to the bottom of your body in the layout:

     `layout.html.erb` (for instance)

    ```html
    <%= dart_include_tag 'dart_app' %>
    <%= javascript_include_tag 'dart' %>
    ```

  4. *Optional:* run `rake pub:get` to respect the dependencies in your `pubspec.yaml`.
  Initially the pubspec contains `rails_ujs` as dependency, this is just basic for now,
  so you probably want to omit it if you're still using JQuery.

  *Note:* you'll need to point `DART_SDK_HOME` to the root of your dart-sdk unless your `pub` executable is in the `PATH`

### Compatibility

###### ruby-dart_js

This gem is needed for the `dart2js` compiler compatibility.

See [ruby-dart_js](https://github.com/m0gg/ruby-dart_js) on github for setup.

```
<%= javascript_include_tag 'dart' %>
```
in the layout needs to stay as it is unless you want to drop
compatibility for browsers without dart support.
It includes the bundled `javascripts/dart.js` from this gem.

This will parse all script-tags with `type="application/dart"` and replace them with tags that request
the appropriate js file.
```html
<script type="application/dart" src="/assets/dart_app.dart"></script>
```
would get
```html
<script type="application/javascript" src="/assets/dart_app.js"></script>
```
To provide the transcompiled version of you dart-file you'll need a js template
with a directive which could look like this
```
//
//= dart dart_app
```

###### Sprockets

`Dart::SprocketsDirectiveDart2js` extends Sprockets base `DirectiveProcessor` and thus each dart-file
included (via `dart` directive) in `.js` templates get compiled and inserted.
