class HomeController < ApplicationController
    before_action :authenticate_user!,:except => %i[ index ]
    #landing page
    def index
    end
end
