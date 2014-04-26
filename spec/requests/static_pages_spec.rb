require 'spec_helper'

describe "Static Pages" do
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home Page" do
    before { visit root_path }
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) } 
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it {should have_link("0 following", href: following_user_path(user))}
        it {should have_link("1 followers", href: followers_user_path(user))}
      end

    end
  end

  describe "Help Page" do
    before { visit help_path }

    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }
    it_should_behave_like "all static pages"
  end

  describe "About Page" do
    before { visit about_path }

    let(:heading) { 'About Us' }
    let(:page_title) { 'About' }
    it_should_behave_like "all static pages"
  end

  describe "Contact Page" do
    before { visit contact_path }

    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }
    it_should_behave_like "all static pages"
  end
  describe "Layout links" do

    link_and_title_pairs = [["About", "About Us"],
     ["Help", "Help"],
      ["Contact","Contact"],
      ["Home",""],
      ["Sign up now!","Sign up"],
      ["sample app",""]
    ]
    link_and_title_pairs.each do |pair|
      link=pair.first
      title=pair.second
      specify "link '#{link}' should point to a page subtitled '#{title}'" do
        visit root_path
        click_link link
        expect(page).to have_title(full_title(title))
      end

    end
  end

end
