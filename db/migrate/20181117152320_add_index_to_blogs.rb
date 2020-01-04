class AddIndexToBlogs < ActiveRecord::Migration[5.2]
  def change
    add_index :blogs, :title
  end
end
