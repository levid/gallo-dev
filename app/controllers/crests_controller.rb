class CrestsController < ApplicationController
respond_to :json
  before_filter :process_canvas_string, :only => :convert

  def index
    @crests = Crest.all
  end

  def show
    @crest = Crest.find(params[:id])
  end

  def new
    @crest = Crest.new(:gallery_id => params[:gallery_id])
  end

  def generate
    @crest_image = CrestCreator.new(params).create_crest
    @crest_image.format = 'png'
    send_data @crest_image.to_blob,
      :stream => 'false',
      :filename => 'test.png',
      :type => 'image/png',
      :disposition => 'inline'
  end

  def process_canvas_string
    if params[:crest][:dataURL]
      # encoded_file = Base64.encode64(File.open('public/uploads/crests/test.png').read)
      # decoded_file = Base64.decode64(params[:crest][:dataURL])
      tempfile = Tempfile.new("#{Rails.public_path}/uploads/tmp/fileupload")
      str = params[:crest][:dataURL].split(",")[1]
      @data = Base64.decode64(str)
      begin
        tempfile.binmode
        tempfile.write @data
        # create a new uploaded file
        # uploaded_file = ActionDispatch::Http::UploadedFile.new(:tempfile => tempfile, :filename => 'crest.png', :original_filename => 'crest_original.png')
        uploaded_file                   = FilelessIO.new(@data)
        uploaded_file.original_filename = "crest.png"
        uploaded_file.content_type      = "image/png"
        @uploaded                       = uploaded_file
        @temp_file                      = tempfile
      # ensure
      #   tempfile.close
      #   tempfile.unlink
      end
    end
  end

  def convert
    if SAVE_TO_DB == true
      params[:crest][:name]             = 'Crest'
      params[:crest][:remote_image_url] = nil
      params[:crest][:gallery_id]       = 1
      params[:crest][:image_data]       = params[:crest][:dataURL]
      params[:crest][:image]            = @uploaded
      params[:crest].delete :dataURL

      @crest = Crest.new(params[:crest])
      if @crest.save
        respond_to do |format|
          format.html { render :template => 'partials/_crest_preview', :locals => { :crest_id => @crest.id, :puzzlize => params[:puzzlize].to_s }, :layout => false }
          format.json{ render json: @crest.gallery, status: :created }
        end
      else
        respond_to do |format|
          format.json{ render json: @crest.errors, status: :unprocessable_entity }
        end
      end
    else
      params[:new_image]                = {}
      params[:new_image][:text_layer]   = @data
      params[:new_image][:puzzlize]     = params[:crest][:puzzlize].to_s
      params[:new_image][:rows]         = params[:crest][:rows] or 6
      params[:new_image][:cols]         = params[:crest][:cols] or 6
      params[:new_image][:temp_image]   = @temp_file

      crest_image = CrestCreator.new(params[:new_image]).create_crest

      render :template => 'partials/_crest_preview', :locals => { :temp_image => crest_image }, :layout => false
    end
  end

  def create
    @crest = Crest.new(params[:crest])
    if @crest.save
      redirect_to @crest.gallery, :notice => "Successfully created crest."
    else
      render :action => 'new'
    end
  end

  def edit
    @crest = Crest.find(params[:id])
  end

  def update
    @crest = Crest.find(params[:id])
    if @crest.update_attributes(params[:crest])
      redirect_to @crest.gallery, :notice  => "Successfully updated crest."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @crest = Crest.find(params[:id])
    @crest.destroy
    redirect_to @crest.gallery, :notice => "Successfully destroyed crest."
  end
end
