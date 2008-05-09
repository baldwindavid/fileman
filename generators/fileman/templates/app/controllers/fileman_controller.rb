class <%= class_name %>sController < ApplicationController

  def index
    @<%= plural_name %> = <%= class_name %>.find(:all)
    respond_to do |format|
      format.html
    end
  end

  def create
    @<%= singular_name %> = <%= class_name %>.new(params[:<%= singular_name %>])
    
    options = params[:options]
    options = string_to_classed_value(options)
    # this needs to be set because options[:extras].each got set to <%= singular_name %>[:field]
    # the form is still expecting options[:extras] when adding the record
    options[:extras] = {}
    
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
              page.insert_html :bottom, "<%= plural_name %>", :partial => 'fileman/list_item', :object => @<%= singular_name %>, :locals => {:options => options, :is_test => false}
              page.visual_effect :highlight, "<%= singular_name %>_#{@<%= singular_name %>.id}" 
              page[:<%= singular_name %>_new].visual_effect :fade, :delay => 1 unless options[:add_browse_visible]
              page.form.reset :<%= singular_name %>_new_form
              page[:<%= singular_name %>_add_facility].remove if options[:single_upload]
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
    options = string_to_classed_value(options)
    # this needs to be set because options[:extras].each got set to <%= singular_name %>[:field]
    # the form is still expecting options[:extras] when updating the record
    options[:extras] = {}

    respond_to do |format|
      if @<%= singular_name %>.update_attributes(params[:<%= singular_name %>])
        flash[:notice] = '<%= class_name %> was successfully updated.'
        format.js do
          responds_to_parent do
            render :update do |page|
              page["<%= singular_name %>_#{@<%= singular_name %>.id.to_s}"].replace :partial => 'fileman/list_item', :object => @<%= singular_name %>, :locals => {:options => options, :is_test => false }
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
