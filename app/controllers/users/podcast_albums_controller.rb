# frozen_string_literal: true

module Users
  # class UsersPagesController
  class PodcastAlbumsController < UsersLayoutController
    before_action :set_podcast_album, only: %i[ show edit update destroy ]

    def new
      @podcast_album = PodcastAlbum.new
    end

    def edit
    end

    def create
      @podcast_album = PodcastAlbum.new(podcast_album_params)
      @podcast_album.user_id = current_user.id
      if @podcast_album.save
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to users_podcasts_path, notice: 'Podcast album was' }
        end
      else
        render 'new', status: :unprocessable_entity
      end
    end

    def update
      respond_to do |format|
        if @podcast_album.update(podcast_album_params)
          format.turbo_stream
          format.html { redirect_to root_url, notice: "Album was successfully updated." }
          format.json { render :show, status: :ok, location: @podcast_album }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @podcast_album.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @podcast_album.destroy
  
      respond_to do |format|
        format.html { redirect_to home_path, notice: "Album was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    def like
      @podcast_album = Confession.find(params[:id])
      LikeService.new(current_user, @podcast_album).like
      redirect_to @podcast_album, notice: 'Podcast album liked/unliked successfully.'
    end

    private

    def set_podcast_album
      @podcast_album = PodcastAlbum.find(params[:id])
    end

    def podcast_album_params
      params.fetch(:podcast_album, {}).permit!
    end
  end
end
