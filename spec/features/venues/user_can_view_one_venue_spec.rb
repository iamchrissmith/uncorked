require 'rails_helper'

RSpec.feature 'Guest can view a list of all venues' do
  let!(:venues) { create_list(:venue, 3) }
  context 'without being logged in' do
    it 'guest can view a single venues' do
      visit root_path

      within '.right' do
        click_on 'Venues'
      end

      expect(current_path).to eq venues_path

      click_on venues.first.name

      expect(current_path).to eq venue_path(venues.first)
      expect(page).to have_content venues.first.name
      expect(page).to have_content(venues.first.street_address)
      expect(page).to have_content(venues.first.city)
      expect(page).to have_content(venues.first.state)
      expect(page).to have_content(venues.first.zip)
    end
  end
end
