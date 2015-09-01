class ChangeMultipleTypeToBooleanForProperties < ActiveRecord::Migration
  def up
    # using change_column caused an error - so making change in two steps
    remove_column(:properties, :multiple_type)
    add_column(:properties, :multiple_type, :boolean)
  end
  
  def down
    remove_column(:properties, :multiple_type)
    add_column(:properties, :multiple_type, :string)
  end
end
