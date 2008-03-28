class <%= class_name %>sController < ApplicationController

  def index
    @<%= plural_name %> = <%= class_name %>.find(:all)
    respond_to do |format|
      format.html
    end
  end

  def create
    @<%= singular_name %> = <%= name %>.new(params[:<%= singular_name %>])
    
    options = params[:options]
    options.each {|k,v| options[k.to_sym] = ( v == 'true') ? true : false }
    
    # if polymorphic or ownership
    #@<%= singular_name %>.whateverable_id = params[:whateverable_id]
    #@<%= singular_name %>.whateverable_type = params[:whateverable_type]
    respond_to do |format|
      if @<%= singular_name %>.save
        flash[:notice] = '<%= class_name %> was successfully created.'
        format.html { redirect_to :back }
        format.js do
          responds_to_parent do
            render :update do |page|
              page.insert_html :bottom, "<%= plural_name %>", :partial => 'fileman/list_item', :object => @<%= singular_name %>, :locals => {:options => options}
              page.visual_effect :highlight, "<%= singular_name %>_#{@<%= singular_name %>.id}" 
              page[:<%= singular_name %>_new].visual_effect :fade, :delay => 1
              page.form.reset :<%= singular_name %>_new_form
            end
          end
        end
      else
        format.js do
          responds_to_parent do
            render :update do |page|
            end
          end
        end
      end
    end
  end

  def update
    @<%= singular_name %> = <%= class_name %>.find(params[:id])

    options = params[:options]
    options.each {|k,v| options[k.to_sym] = ( v == 'true') ? true : false }

    respond_to do |format|
      if @<%= singular_name %>.update_attributes(params[:<%= singular_name %>])
        flash[:notice] = '<%= class_name %> was successfully updated.'
        format.js do
          responds_to_parent do
            render :update do |page|
              page["<%= singular_name %>_#{@<%= singular_name %>.id.to_s}"].replace :partial => 'fileman/list_item', :object => @<%= singular_name %>, :locals => {:options => options}
              page.visual_effect :highlight, "<%= singular_name %>_#{@<%= singular_name %>.id}"
            end
          end
        end
      else
        format.js do
          responds_to_parent do
            render :update do |page|
            end
          end
        end
      end
    end
  end

  def destroy
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
    @<%= singular_name %>.destroy

    respond_to do |format|
      format.js do
        render :update do |page|
          page.remove "<%= singular_name %>_#{@<%= singular_name %>.id}"
        end
      end
    end
  end
  
end
