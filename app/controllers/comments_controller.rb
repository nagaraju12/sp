class CommentsController < ApplicationController
  
	def new
		@comment =Comment.new
	end

	def index
		@comments =Comment.all
	end

	def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article)
  end

 def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article)
  end

  private
    def comment_params
      params.require(:comment).permit(:commenter, :body,:description, :title)
    end
end
