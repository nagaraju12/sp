class CreateBanners < ActiveRecord::Migration
  def change
		create_table :banners do |t|
			t.string   :image_file_name
			t.string   :image_content_type
			t.integer  :image_file_size
			t.text     :image_description

			t.timestamps
		end
	end
end
