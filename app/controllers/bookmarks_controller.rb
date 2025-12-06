class BookmarksController < ApplicationController
  before_action :set_bookmark, only: [:show, :destroy]
  before_action :set_list, only: [:new, :create]


  def index
    @bookmarks = Bookmark.all
  end

  def show
  end

  def new
    @bookmark = Bookmark.new
  end

  def create
    @bookmark = @list.bookmarks.new(bookmark_params)

    if @bookmark.save
      redirect_to list_path(@list)
    else
      render "lists/show", status: :unprocessable_entity
    end
  end

  def destroy
    @bookmark.destroy

    redirect_to list_path(@bookmark.list), status: :see_other
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:bookmarkable_type, :bookmarkable_id)
  end

  def set_list
    @list = List.find(params[:list_id])
  end

  def set_bookmark
    @bookmark = Bookmark.find(params[:id])
  end
end
