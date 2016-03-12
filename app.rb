require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'pry'

require_relative 'models/contact'
also_reload 'models/contact'

get '/' do
  @page = params['page'].to_i
  @total_pages = (Contact.count.to_f / 10).ceil

  if @page < 2
    @page = 1
  elsif @page > @total_pages
    @page = @total_pages
  end

  if @page == 1
    @offset = 0
  else
    @offset = (@page - 1) * 10
  end

  @contacts = Contact.limit(10).offset("#{@offset}")

  erb :index
end

get '/contacts/:id' do
  @contact = Contact.find(params['id'])
  erb :show
end

get '/add' do
  erb :add
end

post '/add' do
  @total_pages = (Contact.count.to_f / 10).ceil
  if params['first_name'].strip.empty? || params['last_name'].strip.empty? || params['phone_number'].strip.empty?
    erb :add
  else
    Contact.create(params)
    redirect "/?page=#{@total_pages}"
  end
end
