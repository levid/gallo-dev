'use strict';

angular.module("ui-crest", []).directive "crestText", ->
  restrict: "EAC"
  link: (scope, elm, attrs) ->
    # by default the values will come in as undefined so we need to setup a
    # watch to notify us when the value changes
    scope.$watch attrs.myText, (value) ->

      elm.text value

      normal =
        path:
          radius: 170
        targets: ".normal"
        showPath: false

      cssWarp normal
      # window.generateCrestSVG(value)
      window.generateKineticSVG(value)