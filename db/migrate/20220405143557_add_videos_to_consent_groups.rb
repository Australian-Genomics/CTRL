class AddVideosToConsentGroups < ActiveRecord::Migration[5.2]
    def change
        add_column :consent_steps, :tour_videos, :text
    end

end
