class <%= class_name %> < ActiveRecord::Base 
  
  # make sure to include the acts_as_iconic plugin
  acts_as_iconic
  
  # for polymorphic associations
  # belongs_to :<%= singular_name %>able, :polymorphic => true
  
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