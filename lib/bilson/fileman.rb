module Bilson
  module Fileman
    def fileman(resource, options = {})
    options = {
      :with_caption => false,
      :display_caption => false,
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
      :add_browse_visible => false,
      :extras => {},
      :association => :has_many,
      :find => false
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
        if options[:association] == :has_many
          owned_resources.each do |item|
            puts render(:partial => "/fileman/list_item", :object => item, :locals => {:resource => resource, :options => options, :is_test => false })
          end
        else
          puts render(:partial => "/fileman/list_item", :object => owned_resources, :locals => {:resource => resource, :options => options, :is_test => false }) if owned_resources
        end 
      end  
    end

    def fileman_add(resource, options)
      haml_tag :div, {:id => "#{resource.tableize.singularize}_add_facility", :style => "#{'display:none' if options[:association] == :has_one && get_owned_resources(resource, options)}"} do
        puts render(:partial => "/fileman/add_facility", :locals => {:resource => resource, :options => options, :is_test => false })
      end
    end

    def fileman_upload_frame    
      # used for responds to parent
      haml_tag :iframe, {:id => "upload_frame", :name => "upload_frame", :style => "width:1px;height:1px;border:0px"} do
      end
    end

    #private

    def get_owned_resources(resource, options)
      if options[:belongs_to]
        resources = eval("options[:belongs_to].#{options[:association] == :has_one ? resource.tableize.singularize : resource.tableize}")
        if options[:find]
          resources = eval("resources.#{options[:find]}")
        end
        return resources
      else
        if options[:find]
          eval("resource.constantize.#{options[:find]}")
        else
          resource.constantize.find_all_by_parent_id(nil)
        end
      end
    end
  end
end