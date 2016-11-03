class SearchController < ApplicationController
  def results
    screen_name = params[:screen_name]

    # TODO: We need to clean up the cache periodically
    # Heroku has a scheduler add-on but it requires payment info
    # I've configured a cleanup task but it's disabled; this probably won't run out of space anytime soon though
    results = Rails.cache.fetch(screen_name, expires_in: 5.minutes) do 
      Twitter::Api.timeline_for(screen_name) 
    end

    respond_to do |format|
      format.json { render json: results }
      format.html { render 'show', locals: { tweets: results.data, error: results.error, screen_name: screen_name } }
    end
  end

  def search
    query = params[:query]

    results = Rails.cache.fetch(query, expires_in: 5.minutes) do 
      Twitter::Api.search_for(query) 
    end

    respond_to do |format|
      format.json { render json: results }
      format.html { render 'show2', locals: { tweets: results.data, error: results.error, query: query } }
    end
  end 

  def home
    respond_to do |format|
      format.html { render 'show', locals: { tweets: [], error: nil } }
    end
  end
end
