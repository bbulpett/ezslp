require "spec_helper"

describe "test static pages" do
  it "verifies some text on each of the static pages" do
    visit "/about"
    page.should have_content("SIMPLE software application")
    visit "/contact"
    page.should have_content("info@ezslp.com")
    visit "/login"
    page.should have_content("Forgot your password?")
    visit "/register"
    page.should have_content("The guest account's username is guest@ezslp.com")
    visit "/screencasts"
    page.should have_content("Intro to ezSLP")
  end
end

