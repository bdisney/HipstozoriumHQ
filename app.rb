#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:hipstozorium.db"

class Post < ActiveRecord::Base 
	has_many :comments
end

class Comment < ActiveRecord::Base
	belongs_to :post
end

before do
	@posts = Post.order('updated_at')
	@posts = Comment.all

end

get '/' do	
	@posts = Post.order "created_at DESC"
	erb :index
end

get '/new' do
	erb	:new
end

post '/new' do
	p = Post.new params[:post]
	p.save

	erb 'Ваш пост записан!'
end

get '/post/:id' do
	@post = Post.find(params[:id])
	@comments = Post.find(params[:id]).comments.reorder('created_at')
	erb :post
end

post '/post/:id' do
	@post = Post.find(params[:id])

	new_comment = Comment.new params[:comment]
	new_comment.post_id = @post.id
	new_comment.save
	
	erb 'Комментарий добавлен!'
	#erb :post
end



