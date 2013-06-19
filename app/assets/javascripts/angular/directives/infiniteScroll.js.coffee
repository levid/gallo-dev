# Define filters and more for your AngularJS app
# Filters can be applied inline in your views/templates HTML to do additional view output processing

# Infinit scroll/pagination, this "directive" binds to the view
# in the application HTML, "when-scrolled" is hooked up to "whenScrolled" here

# bind function to the 'scroll' event
# we listen to the 'scroll' event and calculate when to call the method attached to "when-scrolled"
# if you recall our HTML page, we have: when-scrolled="load_data()"
# in our application script we defined "load_data()"

# calculating the time/space continuum needed to trigger the loading of the next pagination

# from the AngularJS documentation:
# http://docs.angularjs.org/api/ng.$rootScope.Scope#$apply
# $apply() is used to execute an expression in angular from outside
# of the angular framework. (For example from browser DOM events, setTimeout,
# XHR or third party libraries). Because we are calling into the angular
# framework we need to perform proper scope life-cycle of
# exception handling, executing watches.

# The rest are optional filters,
# implementation specific, can skip
angular.module("ui-infinite-scroll", ["ngSanitize"]).directive("whenScrolled", ->
  (scope, elm, attr) ->
    raw = elm[0]
    elm.bind "scroll", ->
      scope.$apply attr.whenScrolled  if raw.scrollTop + raw.offsetHeight >= raw.scrollHeight

).filter("truncate", ->
  (input) ->
    truncate input, 140
).filter("time_ago_in_words", ->
  (input) ->
    moment.utc(input).fromNow()
).filter "urlize", ->
  (input) ->
    urlize input,
      target: "_blank"

