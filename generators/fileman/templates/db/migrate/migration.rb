class Create<%= class_name %>s < ActiveRecord::Migration
  def self.up
    create_table :<%= plural_name %>, :force => true do |t|
      t.integer :parent_id
      t.string  :content_type
      t.string  :filename
      t.string  :thumbnail
      t.integer :size
      t.integer :width
      t.integer :height
      
      # Uncomment for Polymorphic Relationships
      # t.integer :<%= singular_name %>able_id
      # t.string  :<%= singular_name %>able_type
      
      # Uncomment for and change to appropriate owning object type for Single Ownership Relationships
      # t.integer :whatever_id
      
      t.string  :display_name
      t.string  :caption
    end
  end

  def self.down
    drop_table :<%= plural_name %>
  end
end