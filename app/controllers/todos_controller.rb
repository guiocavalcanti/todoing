class TodosController < ApplicationController
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  def create
    @todo = Todo.new(params[:todo])

    respond_to do |format|
      if @todo.save
        format.json { render :json => @todo }
      else
        format.json { render :nothing => true, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @todo = Todo.find(params[:id])

    respond_to do |format|
      if @todo.nil?
        format.json { render :json => { :status => "erro"}, :status => :unprocessable_entity }
      else
        @todo.destroy
        format.json { render :json => { :status => 'ok' }}
      end
    end
  end

  def index
    @todos = Todo.all

    respond_to do |format|
      format.json { render :json => @todos }
    end

  end

  private

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS, DELETE'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.

  def cors_preflight_check
    if request.method == :options
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS, DELETE'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end

end
