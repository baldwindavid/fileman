class <%= class_name %> < ActiveRecord::Base 
  
  # if you are using the acts_as_iconic plugin, you can uncomment for automatic 
  # icons for your attachments (based upon mime type)
  #acts_as_iconic
  
  # for polymorphic associations
  # belongs_to :<%= singular_name %>able, :polymorphic => true
  
  # for single ownership associations
  # belongs_to :whatever_id
  
  has_attachment :storage => :file_system,
                 :processor => :Rmagick,
                 :size => 0..2.megabytes
  validates_as_attachment
    
  def name
    if display_name.blank?
      filename
    else
      display_name
    end
  end
  
end