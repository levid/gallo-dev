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

stage = new Kinetic.Stage(
  container: "container"
  width: 900
  height: 900
)
layer = new Kinetic.Layer()

window.generateKineticSVG = (text) =>

  textpath = new Kinetic.TextPath(
    x: 0
    y: 0
    fill: "#333"
    fontSize: "40"
    fontFamily: 'Bree Serif'
    textAlign: 'center'
    text: text
    id: 'textLayer'
    data: "M21.999,173.666c0,0,74.466-70,227.191-70c152.726,0,228.141,70,228.141,70" # http://mobile.tutsplus.com/tutorials/iphone/using-svg-illustrator-to-create-curvy-text/
  )
  layer.destroy()
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
        url: "#{window.location.href}convert"
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
        $(".hidden-container").html(data)
  )



App.controller 'CrestsCtrl', ['$scope', ($scope) ->
  $scope.myText = " "

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