class <%= controller_class_name %>Controller < ApplicationController
  
  layout 'admin'
  
  before_filter :find_<%= table_name %>, :only => [:show, :destroy, :edit, :update]
  
  # GET /<%= table_name %>
  def index
    @<%= table_name %> = <%= class_name %>.paginate :page => params[:page], :per_page => 10, :order => "created_at DESC, updated_at DESC"
  end

  # GET /<%= table_name %>/1
  def show

  end

  # GET /<%= table_name %>/new
  def new
    @<%= file_name %> = <%= class_name %>.new
  end

  # GET /<%= table_name %>/1/edit
  def edit

  end

  # POST /<%= table_name %>
  def create
    @<%= file_name %> = <%= class_name %>.new(params[:<%= file_name %>])

      if @<%= file_name %>.save
        flash[:notice] = '<%= class_name %> criado(a) com sucesso.'
        redirect_to(<%= table_name %>_url)
      else
        render :action => "new"
      end
  end

  # PUT /<%= table_name %>/1
  def update
      if @<%= file_name %>.update_attributes(params[:<%= file_name %>])
        flash[:notice] = '<%= class_name %> atualizado(a) com sucesso.'
        redirect_to(<%= table_name %>_url)
      else
        render :action => "edit"
      end
  end

  # DELETE /<%= table_name %>/1
  def destroy
    if @<%= file_name %>.destroy
      flash[:notice] = '<%= class_name %> apagado(a) com sucesso.'
    end
    redirect_to(<%= table_name %>_url)
  end
  
  private

  def find_<%= table_name %>
    @<%= file_name %> = <%= class_name %>.find(params[:id])
  rescue
    flash[:notice] = '<%= class_name %> não encontrado(a).'
    redirect_to(<%= table_name %>_url)
  end
  
end
