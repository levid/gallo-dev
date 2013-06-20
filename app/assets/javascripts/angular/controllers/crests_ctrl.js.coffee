'use strict';

# window.generateCrestSVG = (text) =>
#   canvas = document.getElementById("canvas")
#   ctx = canvas.getContext("2d")
#   data = """
#     <svg xmlns='http://www.w3.org/2000/svg' width='500' height='200'>
#       <foreignObject width='100%' height='100%'>
#         <div xmlns='http://www.w3.org/1999/xhtml' style='font-size:40px'>
#           <div id='crest'>
#             <div class='bree box normal' crest-text='' data-my-text='myText' id='crestText'>#{text}</div>
#           </div>
#         </div>
#       </foreignObject>
#     </svg>
#     """
#   DOMURL = self.URL or self.webkitURL or self
#   img = new Image()
#   svg = new Blob([data],
#     type: "image/svg+xml;charset=utf-8"
#   )
#   url = DOMURL.createObjectURL(svg)
#   img.onload = ->
#     ctx.drawImage img, 0, 0
#     DOMURL.revokeObjectURL url

#   img.src = url

# Kinetic.MyTextPath = (config) ->
#   @_initMyTextPath config

# Kinetic.MyTextPath:: =
#   _initMyTextPath: (config) ->
#     Kinetic.TextPath.call this, config

#   _setTextData: ->
#     @attrs.text = " " + @attrs.text
#     that = this
#     size = @_getTextSize(@attrs.text)
#     @textWidth = size.width
#     @textHeight = size.height
#     @glyphInfo = []
#     charArr = @attrs.text.split("")
#     p0 = undefined
#     p1 = undefined
#     pathCmd = undefined
#     pIndex = -1
#     currentT = 0
#     startPos = 0
#     plen = 0
#     i = 0

#     while i < that.dataArray.length
#       plen += that.dataArray[i].pathLength
#       i++

#     startPos = Math.round((plen - that.textWidth) / 2)
#     getNextPathSegment = ->
#       currentT = 0
#       pathData = that.dataArray
#       i = pIndex + 1

#       while i < pathData.length
#         if pathData[i].pathLength > 0
#           pIndex = i
#           return pathData[i]
#         else if pathData[i].command is "M"
#           p0 =
#             x: pathData[i].points[0]
#             y: pathData[i].points[1]
#         i++
#       {}

#     findSegmentToFitCharacter = (c, before) ->
#       glyphWidth = that._getTextSize(c).width + before
#       glyphWidth = 1  if before
#       currLen = 0
#       attempts = 0
#       needNextSegment = false
#       p1 = `undefined`
#       while Math.abs(glyphWidth - currLen) / glyphWidth > 0.01 and attempts < 25
#         attempts++
#         cumulativePathLength = currLen
#         while pathCmd is `undefined`
#           pathCmd = getNextPathSegment()
#           if pathCmd and cumulativePathLength + pathCmd.pathLength < glyphWidth
#             cumulativePathLength += pathCmd.pathLength
#             pathCmd = `undefined`
#         return `undefined`  if pathCmd is {} or p0 is `undefined`
#         needNewSegment = false
#         switch pathCmd.command
#           when "L"
#             if Kinetic.Path.getLineLength(p0.x, p0.y, pathCmd.points[0], pathCmd.points[1]) > glyphWidth
#               p1 = Kinetic.Path.getPointOnLine(glyphWidth, p0.x, p0.y, pathCmd.points[0], pathCmd.points[1], p0.x, p0.y)
#             else
#               pathCmd = `undefined`
#           when "A"
#             start = pathCmd.points[4]
#             dTheta = pathCmd.points[5]
#             end = pathCmd.points[4] + dTheta
#             if currentT is 0
#               currentT = start + 0.00000001
#             else if glyphWidth > currLen
#               currentT += (Math.PI / 180.0) * dTheta / Math.abs(dTheta)
#             else
#               currentT -= Math.PI / 360.0 * dTheta / Math.abs(dTheta)
#             if Math.abs(currentT) > Math.abs(end)
#               currentT = end
#               needNewSegment = true
#             p1 = Kinetic.Path.getPointOnEllipticalArc(pathCmd.points[0], pathCmd.points[1], pathCmd.points[2], pathCmd.points[3], currentT, pathCmd.points[6])
#           when "C"
#             if currentT is 0
#               if glyphWidth > pathCmd.pathLength
#                 currentT = 0.00000001
#               else
#                 currentT = glyphWidth / pathCmd.pathLength
#             else if glyphWidth > currLen
#               currentT += (glyphWidth - currLen) / pathCmd.pathLength
#             else
#               currentT -= (currLen - glyphWidth) / pathCmd.pathLength
#             if currentT > 1.0
#               currentT = 1.0
#               needNewSegment = true
#             p1 = Kinetic.Path.getPointOnCubicBezier(currentT, pathCmd.start.x, pathCmd.start.y, pathCmd.points[0], pathCmd.points[1], pathCmd.points[2], pathCmd.points[3], pathCmd.points[4], pathCmd.points[5])
#           when "Q"
#             if currentT is 0
#               currentT = glyphWidth / pathCmd.pathLength
#             else if glyphWidth > currLen
#               currentT += (glyphWidth - currLen) / pathCmd.pathLength
#             else
#               currentT -= (currLen - glyphWidth) / pathCmd.pathLength
#             if currentT > 1.0
#               currentT = 1.0
#               needNewSegment = true
#             p1 = Kinetic.Path.getPointOnQuadraticBezier(currentT, pathCmd.start.x, pathCmd.start.y, pathCmd.points[0], pathCmd.points[1], pathCmd.points[2], pathCmd.points[3])

#         currLen = Kinetic.Path.getLineLength(p0.x, p0.y, p1.x, p1.y)  if p1 isnt `undefined`

#         if needNewSegment
#           needNewSegment = false
#           pathCmd = `undefined`

#     j = 0

#     while j < startPos
#       charArr.unshift " "
#       i++

#     i = 0
#     while i < charArr.length
#       findSegmentToFitCharacter charArr[i], i < startPos
#       break  if p0 is `undefined` or p1 is `undefined`
#       width = Kinetic.Path.getLineLength(p0.x, p0.y, p1.x, p1.y)
#       kern = 0
#       midpoint = Kinetic.Path.getPointOnLine(kern + width / 2.0, p0.x, p0.y, p1.x, p1.y)
#       rotation = Math.atan2((p1.y - p0.y), (p1.x - p0.x))

#       @glyphInfo.push
#         transposeX: midpoint.x
#         transposeY: midpoint.y
#         text: charArr[i]
#         rotation: rotation
#         p0: p0
#         p1: p1

#       p0 = p1
#       i++

# Kinetic.Util.extend Kinetic.MyTextPath, Kinetic.TextPath


App.controller 'CrestsCtrl', ['$scope', ($scope) ->
  $scope.myText = " "


  # For use in jQuery

  # Some mobile browsers (ie. Mobile Safari) don't focus their associated inputs
  # so we force that behavior when possible.

  # First we check when a label is touched and is associated with a radio or checkbox input,
  # if so then we mark it as having focus.

  # Should the user move via touch on the label instead of pressing on the label we blur the
  # focus on the input if it's a radio or checkbox. This is to avoid misinterpreting a scroll
  # for a press.

  # If the press is finished and we still have focus on the radio or checkbox inputs then
  # trigger a click event which will do the rest. Focus all other input types.
  $(document).on("touchstart", "label[for]", (event) ->
    input = (if event.target.control then $(event.target.control) else $("#" + event.target.htmlFor))
    input.focus()  if input.is("[type=checkbox], [type=radio]")
  ).on("touchmove", (event) ->
    input = (if event.target.control then $(event.target.control) else $("#" + event.target.htmlFor))
    input.blur()  if input.is("[type=checkbox], [type=radio]")
  ).on "touchend", (event) ->
    input = (if event.target.control then $(event.target.control) else $("#" + event.target.htmlFor))
    if input.is("[type=checkbox], [type=radio]")
      if input.is(":focus")
        input.click()
      else
        input.focus()





  # http://stackoverflow.com/questions/16010275/how-to-center-text-along-kinetic-textpath-with-kineticjs
  # get the length of the path and subtract the text lenght and divide by 2 to get the center

  #http://stackoverflow.com/questions/16010275/how-to-center-text-along-kinetic-textpath-with-kineticjs
  # use before to determine glyph width

  # 4 = theta

  # 5 = dTheta

  # Just in case start is 0

  #http://stackoverflow.com/questions/16010275/how-to-center-text-along-kinetic-textpath-with-kineticjs
  # probably not really efficient but pad the charArr with spaces

  # Find p1 such that line segment between p0 and p1 is approx. width of glyph
  #http://stackoverflow.com/questions/16010275/how-to-center-text-along-kinetic-textpath-with-kineticjs
  # set before to true if less than startPos, this will result in glyph width of 1px

  # Note: Since glyphs are rendered one at a time, any kerning pair data built into the font will not be used.
  # Can foresee having a rough pair table built in that the developer can override as needed.

  # placeholder for future implementation


  # svg = "M10,10 C0,0 10,150 100,100 S300,150 400,50"
  # svg = "M87.614,243.922c0-48.515,50.317-87.844,112.386-87.844 s112.386,39.329,112.386,87.844"
  # svg = "M87.614,243.922c0-90.673,50.317-164.179,112.386-164.179 s112.386,73.505,112.386,164.179"


  # textpath = new Kinetic.MyTextPath(
  #   x: 0
  #   y: 0
  #   fill: "#333"
  #   fontSize: "18"
  #   fontFamily: "Arial"
  #   text: document.getElementById("textVal").value
  #   data: svg
  # )
  # layer.add textpath
  # stage.add layer

  stage = new Kinetic.Stage(
    container: "container"
    width: 1000
    height: 1000
  )

  $scope.stage = stage

  layer = new Kinetic.Layer()

  # Center text using: http://jsfiddle.net/sEtzy/

  svg =  """
    M148.319,959.261c-29.369-66.689-45.675-140.429-45.675-217.976
c0-298.988,242.376-541.364,541.363-541.364c298.987,0,541.363,242.376,541.363,541.364c0,82.877-18.623,161.404-51.914,231.625
  """

  textpath = new Kinetic.MyTextPath(
    x: 0
    y: 0
    width: 1000
    height: 1000
    fill: "#333"
    fontSize: "40"
    fontFamily: 'Bree Serif'
    text: $("#myText").val()
    offset: [150, 0]
    id: 'textLayer'
    data: svg # http://mobile.tutsplus.com/tutorials/iphone/using-svg-illustrator-to-create-curvy-text/
    # data: "M21.999,173.666c0,0,74.466-70,227.191-70c152.726,0,228.141,70,228.141,70" # http://mobile.tutsplus.com/tutorials/iphone/using-svg-illustrator-to-create-curvy-text/
  )
  # layer.destroy()
  layer.add textpath
  stage.add layer

  $scope.updateText = (value) ->
    $('.kineticjs-content').show()
    $('#crestImage').show()
    $(".hidden-container").hide()
    textpath.setText value
    stage.draw()

  window.generateKineticSVG = (text) =>

    $('.kineticjs-content').show()
    $('#crestImage').show()
    $(".hidden-container").hide()

    textpath = new Kinetic.MyTextPath(
      x: 0
      y: 0
      fill: "#333"
      fontSize: "40"
      fontFamily: 'Bree Serif'
      text: $("#myText").val()
      id: 'textLayer'
      data: svg # http://mobile.tutsplus.com/tutorials/iphone/using-svg-illustrator-to-create-curvy-text/
      # data: "M21.999,173.666c0,0,74.466-70,227.191-70c152.726,0,228.141,70,228.141,70" # http://mobile.tutsplus.com/tutorials/iphone/using-svg-illustrator-to-create-curvy-text/
    )
    # layer.destroy()
    layer.add textpath
    stage.add layer

  $("form#title-form input[type=submit]").on 'click', (e) =>
    e.preventDefault()
    puzzlize = $("#puzzle").is(':checked')
    stage.toDataURL(
      callback: (dataURL) ->
         # here you can do anything you like with the data url.
         # In this tutorial we'll just open the url with the browser
         # so that you can see the result as an image
        $.ajax(
          type: "post"
          url: "#{current_path}convert"
          beforeSend: (xhr) ->
            xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
          data:
            # my_stuff:
            #   file: dataURL
            #   original_filename: "what.png"
            #   filename: "test.png"
            crest:
              dataURL: dataURL
            puzzlize: puzzlize.toString()
        ).done (data) ->
          $('.kineticjs-content').hide()
          $('#crestImage').hide()
          $(".hidden-container").show().html(data)
    )


  $(document).ready ->
    $("#myText").focus()

  $(window).load ->

    # $("#crest").on 'click', (e) ->
    #   e.preventDefault()

    #   html2canvas $("#crest"),
    #     onrendered: (canvas) ->
    #       # canvas is the final rendered <canvas> element
    #       $("#result").append(canvas).show()
    #       $("#result").css
    #         width: $("#crest").css 'width'
    #         height: $("#crest").css 'height'

    #     letterRendering: true
    #     background: undefined
    #     width: 1000
    #     height: 1000

    window.WebFontConfig =
      google:
        families: ["Bree+Serif::latin"]

      fontactive: (fontFamily, fontDescription) ->
        warpText()

    (->
      wf = document.createElement("script")
      wf.src = ((if "https:" is document.location.protocol then "https" else "http")) + "://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js"
      wf.type = "text/javascript"
      wf.async = "true"
      s = document.getElementsByTagName("script")[0]
      s.parentNode.insertBefore wf, s
    )()

    warpText = () =>
      # cssWarp normal, normalinside, alignedleft, alignedleftinside, alignedleft90deg, alignedleft90deginside, alignedright, alignedrightinside, alignedright90deg, alignedright90deginside, normalskewed, normalstep
    #   cssWarp normal


    # normal =
    #   path:
    #     radius: 150

    #   targets: ".normal"

    #   css: "visibility: visible; position: relative; top: 0px; width: 300px; height: 300px;"

    # normalinside =
    #   path:
    #     radius: 100
    #     textPosition: "inside"

    #   targets: ".normalinside"
    #   showPath:
    #     thickness: 1
    #     color: "white"

    #   css: "visibility: visible; position: relative; top: 0px; width: 200px; height: 200px;"

    # alignedleft =
    #   path:
    #     radius: 100

    #   targets: ".alignedleft"
    #   align: "left"
    #   showPath:
    #     thickness: 1
    #     color: "white"

    #   css: "visibility: visible; position: relative; top: 0px; width: 200px; height: 200px;"

    # alignedleftinside =
    #   path:
    #     radius: 100
    #     textPosition: "inside"

    #   targets: ".alignedleftinside"
    #   align: "left"
    #   showPath:
    #     thickness: 1
    #     color: "white"

    #   css: "visibility: visible; position: relative; top: 0px; width: 200px; height: 200px;"

    # alignedleft90deg =
    #   path:
    #     radius: 100
    #     angle: "90deg"

    #   targets: ".alignedleft90deg"
    #   align: "left"
    #   showPath:
    #     thickness: 1
    #     color: "white"

    #   css: "visibility: visible; position: relative; top: 0px; width: 200px; height: 200px;"

    # alignedleft90deginside =
    #   path:
    #     radius: 100
    #     angle: "90deg"
    #     textPosition: "inside"

    #   targets: ".alignedleft90deginside"
    #   align: "left"
    #   showPath:
    #     thickness: 1
    #     color: "white"

    #   css: "visibility: visible; position: relative; top: 0px; width: 200px; height: 200px;"

    # alignedright =
    #   path:
    #     radius: 100

    #   targets: ".alignedright"
    #   align: "right"
    #   showPath:
    #     thickness: 1
    #     color: "white"

    #   css: "visibility: visible; position: relative; top: 0px; width: 200px; height: 200px;"

    # alignedrightinside =
    #   path:
    #     radius: 100
    #     textPosition: "inside"

    #   targets: ".alignedrightinside"
    #   align: "right"
    #   showPath:
    #     thickness: 1
    #     color: "white"

    #   css: "visibility: visible; position: relative; top: 0px; width: 200px; height: 200px;"

    # alignedright90deg =
    #   path:
    #     radius: 100
    #     angle: "90deg"

    #   targets: ".alignedright90deg"
    #   align: "right"
    #   showPath:
    #     thickness: 1
    #     color: "white"

    #   css: "visibility: visible; position: relative; top: 0px; width: 200px; height: 200px;"

    # alignedright90deginside =
    #   path:
    #     radius: 100
    #     angle: "90deg"
    #     textPosition: "inside"

    #   targets: ".alignedright90deginside"
    #   align: "right"
    #   showPath:
    #     thickness: 1
    #     color: "white"

    #   css: "visibility: visible; position: relative; top: 0px; width: 200px; height: 200px;"

    # normalskewed =
    #   path:
    #     radius: 100

    #   targets: ".normalskewed"
    #   rotationMode: "skew"
    #   showPath:
    #     thickness: 1
    #     color: "white"

    #   css: "visibility: visible; position: relative; top: 0px; width: 200px; height: 200px;"

    # normalstep =
    #   path:
    #     radius: 100

    #   targets: ".normalstep"
    #   rotationMode: "step"
    #   fixshadow: false
    #   showPath:
    #     thickness: 1
    #     color: "white"

    #   css: "visibility: visible; position: relative; top: 0px; width: 200px; height: 200px;"


]