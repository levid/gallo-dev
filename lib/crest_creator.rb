class CrestCreator
  require 'RMagick'
  include Magick

  # Initalize method for the CrestCreator
  #
  # @param [Array] params
  #   The params to configure the crest creator (optional) ex:
  #     :type - [Array] "layer1.png", "layer2.png", "layer3.png", "layer4.png", "layer5.png", "layer6.png"]
  #
  def initialize(params)
    @crest_id   = params[:crest_id]   ? params[:crest_id].to_s    : ''
    @names      = params[:img_array]  ? params[:img_array]        : ["crest_01.png", "transparent.png"]
    @img_path   = params[:img_path]   ? params[:img_path]         : "public/crests/"
    @rows       = params[:rows]       ? params[:rows].to_i        : 6
    @cols       = params[:cols]       ? params[:cols].to_i        : 6
    @text       = params[:text]       ? params[:text].to_i        : ''
    @tempfile   = params[:temp_image] ? params[:temp_image]       : ''

    # if @crest_id
    #   base64_data = Crest.find(@crest_id).image_data
    #   new_img     = Magick::ImageList.new
    #   decoded     = Base64.decode64(base64_data.split(",")[1])
    #   @text_layer = new_img.from_blob(decoded) unless decoded.blank?
    # end

    if !@crest_id.blank?
      crest_image = Crest.find(@crest_id).image
      @text_layer = Magick::Image.read(crest_image.path)[0]
      @text_layer.background_color = "none"
    else
      image = Magick::Image.read(@tempfile.path)[0]
      image.background_color = "none"
      @text_layer = image
    end

    if params[:puzzlize] == "true"
      @puzzle = true
    else
      @puzzle = false
    end
  end

  # Factory method that generates the crest images
  #
  # @return [Object] Magick:Image
  def create_crest
    @layers         = setup_layers(@names, @img_path)
    @layered_image  = create_composite(@layers)
    @puzzle_image   = puzzlize(@layered_image, @rows, @cols) if @puzzle == true

    # txt = Draw.new
    # draw.annotate(img, width, height, x, y, text) [ { additional parameters } ] -> self
    # @layered_image.annotate(txt, 0,0,0,0, @text){
    #   self.gravity = Magick::CenterGravity
    #   self.pointsize = 50
    #   # txt.stroke = '#000000'
    #   self.font_family = "Arial"
    #   self.fill = '#000000'
    #   self.font_weight = Magick::BoldWeight
    #   self.translate(0, 0)
    # }

    # result = @layered_image.distort(Magick::ArcDistortion, [0]) do
    #    self.define "distort:viewport", "44x44+15+0"
    #    self.define "distort:scale", 2
    #    self.define "distort:size", "320x100"
    #    self.define "distort:font", "Candice"
    #    self.define "distort:xc", "lightblue"
    #    self.define "distort:pointsize", "72"
    #    self.define "distort:fill", "navy"
    #    self.define "distort:annotate", "25+65"
    #    self.define "distort:Arc", "120"
    #    self.define "distort:trim", "+repage"
    #    self.define "distort:bordercolor", "lightblue"
    #    self.define "distort:border", "10"
    # end

    # result.write("distored.png")
    # return result

    if @tempfile
      @path = "crests/new_test.png"
      @tempfile.close
      @tempfile.unlink
    end

    if @puzzle_image
      if @tempfile
        picture = @puzzle_image
        picture.write("#{Rails.public_path}/#{@path}")
        return @path
      else
        return @puzzle_image
      end
    else
      if @tempfile
        picture = @layered_image
        picture.write("#{Rails.public_path}/#{@path}")
        return @path
      else
        return @layered_image
      end
    end
  end

  def create_composite(layers)
    composite = Array.new
    layers.each_with_index do |layer, index|
      if layers.size > 1
        if index == 0
          composite[index] = Array.new
          composite[index] = layers[0].composite(layers[1], Magick::CenterGravity, Magick::OverCompositeOp)
        elsif index > 0
          composite[index] = composite[index-1].composite(layer, Magick::CenterGravity, Magick::OverCompositeOp)
        end
      end
      if @text_layer
        # @text_layer.change_geometry!('900x900') { |cols, rows, img|
        #   img.resize!(cols, rows)
        # }
        # @text_layer.gravity = NorthGravity
        # @text_layer.geometry = "#{@cols}x#{@rows}"
        composite[index+1] = composite[index].composite(@text_layer, Magick::CenterGravity, 0, 20, Magick::OverCompositeOp)
      end
    end
    composite[composite.size-1]
  end

  def setup_layers(names, img_path)
    layers = Array.new
    names.each_with_index do |name, index|
      layers << Image.read("#{img_path}#{name}")[0]
    end
    layers
  end

  def puzzlize(img, rows, cols)
    width = img.columns / cols
    height = img.rows / rows

    # create a new empty image to composite the tiles upon:
    puzzle_img = Magick::Image.new(img.columns, img.rows)
    puzzle_img.background_color = "none"

    # tiles will be an array of Image objects
    tiles = (cols * rows).times.inject([]) do |arr, idx|
      arr << Magick::Image.constitute(width, height, 'RGBA', img.dispatch(idx % cols * width, idx / cols * height, width, height, 'RGBA' ))
    end

    # Basically go through the same kind of loop, but using composite
    tiles.shuffle.each_with_index do |tile, idx|
      puzzle_img.composite!(tile, idx % cols * width, idx / cols * height, Magick::OverCompositeOp)
    end

    # Output the final image
    puzzle_img.write("puzzle-image.png")
  end
end