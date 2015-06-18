  class BannersController < ApplicationController
  before_action :set_banner, only: [:show, :edit, :update, :destroy]


  def index
    @banner_images = Banner.all
  end
  
  def new
    @banner_image = Banner.new
  end
  
  def create
    @banner_image = Banner.new(params[:banner_image])
    if @banner_image.save
      redirect_to banners_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @banner_image = Banner.find(params[:id])
  end
  
  def update
    @banner_image = Banner.find(params[:id])
    if @banner_image.update_attributes(params[:banner_image])
      redirect_to bannesr_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @banner_image = Banner.find(params[:id])
    @banner_image.destroy
    redirect_to banners_path
  end
  
end