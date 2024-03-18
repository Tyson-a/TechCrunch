class PagesController < ApplicationController
  def about
    @about_page = AboutPage.first
  end

  def contact
    @contact_page = ContactPage.first
  end
end
