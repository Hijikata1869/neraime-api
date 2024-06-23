class RemoveNumberOfPeopleFromCrowdednesses < ActiveRecord::Migration[7.1]
  def change
    remove_column :crowdednesses, :number_of_people, :string
  end
end
