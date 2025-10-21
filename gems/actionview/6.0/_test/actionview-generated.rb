module Test
	class View
		include ActionView::Helpers

		def view_template_form
			form_for @user do |f|
        f.select :country, [ "USA", "Canada", "Mexico" ], include_blank: true
				f.select :country, [ "USA", "Canada", "Mexico" ], include_blank: true do
					"Custom Option"
				end

				f.collection_radio_buttons :country, [ "USA", "Canada", "Mexico" ], :to_s, :to_s
				f.collection_radio_buttons :country, [ "USA", "Canada", "Mexico" ], :to_s, :to_s do |b|
					b.label { b.radio_button }
				end

				f.collection_check_boxes :country, [ "USA", "Canada", "Mexico" ], :to_s, :to_s
				f.collection_check_boxes :country, [ "USA", "Canada", "Mexico" ], :to_s, :to_s do |b|
					b.label { b.check_box }
				end

        f.submit
      end

			select :country, [ "USA", "Canada", "Mexico" ], include_blank: true

			select :country, [ "USA", "Canada", "Mexico" ], include_blank: true do
				"Custom Option"
			end

			collection_check_boxes :user, :country, [ "USA", "Canada", "Mexico" ], :to_s, :to_s
			collection_check_boxes :user, :country, [ "USA", "Canada", "Mexico" ], :to_s, :to_s do |b|
				b.label { b.check_box }
		  end

			collection_radio_buttons :user, :country, [ "USA", "Canada", "Mexico" ], :to_s, :to_s
			collection_radio_buttons :user, :country, [ "USA", "Canada", "Mexico" ], :to_s, :to_s do |b|
				b.label { b.radio_button }
		  end
			
			label_tag :country, "Country Label"
			label_tag :country, "Country Label" do
				"Custom Label Content"
			end

			button_tag "Click Me"
			button_tag "Click Me" do
				"Custom Button Content"
			end
		end
	end
end
