# $(document).ready =>

#   canvas  = document.getElementById("cvs")

#   if canvas
#     context = canvas.getContext("2d")
#     centerX = canvas.width / 2
#     centerY = canvas.height / 2
#     angle = Math.PI * 0.8
#     radius = 150
#     context.font = "50pt Calibri"
#     context.textAlign = "center"
#     context.fillStyle = "blue"
#     context.strokeStyle = "blue"
#     context.lineWidth = 4

#   $("form#title-form input[type=submit]").on 'click', (e) =>
#     e.preventDefault()
#     title = $("#title").val()
#     puzzlize = $("#puzzle").is(':checked')

#     drawTextAlongArc context, "#{title}", centerX, centerY, radius, angle

#     # draw circle underneath text
#     context.arc centerX, centerY, radius - 10, 0, 2 * Math.PI, false
#     context.stroke()

#     saveCanvas(canvas, context, title, puzzlize)

#   drawTextAlongArc = (context, str, centerX, centerY, radius, angle) =>
#     len = str.length
#     s = undefined
#     context.save()
#     context.translate centerX, centerY
#     context.rotate -1 * angle / 2
#     context.rotate -1 * (angle / len) / 2
#     n = 0

#     while n < len
#       context.rotate angle / len
#       context.save()
#       context.translate 0, -1 * radius
#       s = str[n]
#       context.fillText s, 0, 0
#       context.restore()
#       n++
#     context.restore()


#   saveCanvas = (canvas, context, title, puzzlize) =>
#     if canvas
#       # context = canvas.getContext("2d")
#       # context.font = "100pt Helvetica Neue"
#       # context.fillText title, 300, 750
#       dataURL = canvas.toDataURL("image/png")
#       # context = canvas.getContext("2d")
#       # base64 = dataURL.replace(/^data:image\/(png|jpg);base64,/, "")
#       # $(window).location = 'http://localhost:3000/convert?base64='+base64

#       $.ajax(
#         type: "post"
#         url: "http://localhost:3000/convert"
#         beforeSend: (xhr) ->
#           xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
#         data:
#           # my_stuff:
#           #   file: dataURL
#           #   original_filename: "what.png"
#           #   filename: "test.png"
#           crest:
#             dataURL: dataURL
#           puzzlize: puzzlize.toString()
#       ).done (data) ->
#         $(".hidden-container").html(data)


#       # # TODO: get the URI
#       # img = new Image()
#       # context.drawImage img, 0, 0

#       # img.src = dataURL