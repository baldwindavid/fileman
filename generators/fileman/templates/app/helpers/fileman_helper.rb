module FilemanHelper

  # :resource_title
  # :polymorphic => true || false
  # :polymorphic_name => example: attachable, phonable, edible 
  #   _id and _type will automatically be added this name
  #   default is resource name + able => ex. attachment would become attachmentable (stupid)
  # :belongs_to => object that owns this resource
  
  # Example Model associations....
  # - has_many :documents, :as => :documentable, :dependent => :destroy
  # - has_many :attachments

  def fileman(action, resource, options = {})
    
    options[:resource_title] ||= resource
    options[:polymorphic] ||= false
    options[:polymorphic_name] ||= "#{resource.downcase}able"
    options[:belongs_to] ||= false
    
    if action == :add
      fileman_add(resource, options)
    elsif action == :list
      fileman_list(resource, options)
    end
    
    # used for responds to parent
    haml_tag :iframe, {:id => :upload_frame, :name => :upload_frame, :style => "width:1px;height:1px;border:0px"}
    
  end

  # takes resource file Model name => ex. Attachment, Document, Image
  # Options
  #   - belongs_to
  def fileman_list(resource, options)
    haml_tag :ul, {:id => resource.tableize, :class => 'none'} do
      owned_resources = options[:belongs_to] ? eval("options[:belongs_to].#{resource.tableize}") : resource.constantize.find(:all)
      owned_resources.each do |item|
        puts render :partial => "/fileman/list_item", :object => item, :locals => {:resource => resource }
      end
    end  
  end

  def fileman_add(resource, options)
    puts link_to_function "Add #{options[:resource_title]}", visual_effect(:toggle_appear, "#{resource.downcase}_new")
    haml_tag :div, {:id => "#{resource.downcase}_new", :style => 'display:none'} do
      puts render :partial => "/fileman/new_form", :locals => {:options => options, :resource => resource}
    end
  end
end