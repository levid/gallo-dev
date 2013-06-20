'use strict';

angular.module("ui-crest", []).directive("crestText", ->
  restrict: "EAC"
  link: (scope, elm, attrs) ->
    # by default the values will come in as undefined so we need to setup a
    # watch to notify us when the value changes
    scope.$watch attrs.myText, (value) ->

      if value.length < 37
        scope.updateText value

      # normal =
      #   path:
      #     radius: 170
      #   targets: ".normal"
      #   showPath: false

      # cssWarp normal
      # window.generateCrestSVG(value)
      # window.generateKineticSVG(value)
)

# angular.module('ui-onkeyup', []).directive "onKeyUp", ->
#   restrict: "EAC"
#   link: (scope, elm, attrs) ->
#     # elm.bind "keyup", () ->
#     #   scope.$apply(attrs.onKeyUp)
#     keyupFn = scope.$eval(attrs.onKeyUp)
#     elm.bind "keyup", (evt) ->
#       scope.$apply(->
#         keyupFn.call(scope, evt.which)
#       )