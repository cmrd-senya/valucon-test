# docs
class PhotosController < ApplicationController
  def index
    render json: photos_presenter(Photo.all)
  end

  def create
    result = Photo.new(photo_params).save
    render nothing: true, status: result ? 200 : 400
  end

  private

  def photo_params
    params.require(:photo).permit(:image)
  end

  def photos_presenter(photos)
    photos.map do |model|
      { url: model.image.url }
    end.as_json
  end
end
