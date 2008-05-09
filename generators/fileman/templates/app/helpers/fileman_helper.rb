module FilemanHelper

  def fileman(resource, options = {})
  options = {
    :with_caption => false,
    :with_display_name => true,
    :with_icon => false,
    :belongs_to => false,
    :with_delete => true,
    :with_update => true,
    :facility => :all,
    :with_link => true,
    :with_image => false,
    :image_size => false,
    :polymorphic => false,
    :polymorphic_name => "#{resource.tableize.singularize}able",
    :single_upload => false,
    :add_browse_visible => false
  }.merge(options)
    
    haml_tag :div, {:class => 'fileman'} do
      if options[:facility] == :add
        fileman_add(resource, options)
      elsif options[:facility] == :list
        fileman_list(resource, options)
      else
        fileman_add(resource, options)
        fileman_list(resource, options)
      end
      fileman_upload_frame
    end
    
  end

  def fileman_list(resource, options)
    haml_tag :ul, {:id => resource.tableize, :style => 'list-style:none; margin-left:0'} do
      owned_resources = get_owned_resources(resource, options)
      owned_resources.each do |item|
        puts render(:partial => "/fileman/list_item", :object => item, :locals => {:resource => resource, :options => options })
      end
    end  
  end

  def fileman_add(resource, options)
    unless at_limit(resource, options)
      haml_tag :div, {:id => "#{resource.tableize.singularize}_add_facility"} do
        puts link_to_function("Add #{options[:resource_title]}", visual_effect(:toggle_appear, "#{resource.tableize.singularize}_new")) unless options[:single_upload] || options[:add_browse_visible]
        haml_tag :div, {:id => "#{resource.tableize.singularize}_new", :style => "#{'display:none' unless options[:single_upload] || options[:add_browse_visible]}"} do
          puts render(:partial => "/fileman/new_form", :locals => {:options => options, :resource => resource})
        end
      end
    end
  end
  
  def fileman_upload_frame    
    # used for responds to parent
    haml_tag :iframe, {:id => "upload_frame", :name => "upload_frame", :style => "width:1px;height:1px;border:0px"} do
    end
  end
  
  private
  
  def get_owned_resources(resource, options)
    options[:belongs_to] ? eval("options[:belongs_to].#{resource.tableize}") : resource.constantize.find_all_by_parent_id(nil)
  end
  
  def at_limit(resource, options)
    if options[:single_upload]
      get_owned_resources(resource, options).count >= 1
    else
      false
    end
  end
  
end