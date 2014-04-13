require 'spec_helper'

describe "Static Pages" do
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  describe "Home Page" do
    it "should have the content 'Sample App'" do
      visit home_path
      expect(page).to have_content('Sample App')
    end
    it "should have the base title" do
      visit home_path
      expect(page).to have_title("#{base_title}")
    end
    it "should not have a custom page title" do
      visit home_path
      expect(page).to_not have_title("| Home")
    end
  end

  describe "Help Page" do
    it "should have the content 'Help'" do
      visit help_path
      expect(page).to have_content('Help')
    end
    it "should have the right title" do
      visit help_path
      expect(page).to have_title("#{base_title} | Help")
    end
  end

  describe "About Page" do
    it "should have the content 'About Us'" do
      visit about_path
      expect(page).to have_content('About Us')
    end
    it "should have the right title" do
      visit about_path
      expect(page).to have_title("#{base_title} | About")
    end
  end

  describe "Contact Page" do
    it "should have the content 'Contact'" do
      visit contact_path
      expect(page).to have_selector('h1', text: 'Contact')
    end
    it "should have the title 'Contact'" do
      visit contact_path
      expect(page).to have_title("#{base_title} | Contact")
    end
  end
end
