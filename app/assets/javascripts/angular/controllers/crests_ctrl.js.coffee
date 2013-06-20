'use strict';

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
$("#title-form label").on("click", (event) ->
  input = $("#myText")
  input.focus() if input.is("[type=text]")
).on("touchstart", (event) ->
  input = $("#myText")
  input.focus() if input.is("[type=text]")
).on("touchmove", (event) ->
  input = $("#myText")
  input.blur()  if input.is("[type=text]")
).on "touchend", (event) ->
  input = $("#myText")
  if input.is("[type=text]")
    if input.is(":focus")
      input.click()
    else
      input.focus()


App.controller 'CrestsCtrl', ['$scope', ($scope) ->
  $scope.myText = " "




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