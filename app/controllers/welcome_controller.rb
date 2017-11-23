class WelcomeController < ApplicationController
  def test
    api_response = RestClient.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/Spain/madrid.json")
    puts 'Response', response
    response = JSON.parse(api_response.body)
    @results = {}
    @results[:location] = response['location']['city']
    @results[:temp_f] = response['current_observation']['temp_f']
    @results[:temp_c] = response['current_observation']['temp_c']
    @results[:weather_icon] = response['current_observation']['icon_url']
    @results[:weather_words] = response['current_observation']['weather'] 
    @results[:forecast_link] = response['current_observation']['forecast_url']
    @results[:real_feel] = response['current_observation']['feelslike_c']
  end

  def index
  	@city = params[:city]
  	@q = params[:q]
  	@results = {}
  	if @city
        api_response = RestClient.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/Spain/#{@city.gsub(" ", "_")}.json", {accept: :json})
        response = JSON.parse(api_response.body)
        if response['response']['error'].blank?
          if response['location']
            @results[:location] = response['location']['city']
            @results[:temp_f] = response['current_observation']['temp_f']
            @results[:temp_c] = response['current_observation']['temp_c']
            @results[:weather_icon] = response['current_observation']['icon_url']
            @results[:weather_words] = response['current_observation']['weather'] 
            @results[:forecast_link] = response['current_observation']['forecast_url']
            @results[:real_feel] = response['current_observation']['feelslike_c']
          elsif response['response']['results']
            @multiple_results = response['response']['results']
          end
        else
          redirect_to root_path, alert: response['response']['error']['description']
        end
    elsif @q
  		api_response = RestClient.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/#{@q}.json", {accept: :json})
  		response = JSON.parse(api_response.body)
  		puts 'dadsadasd', response
  		@results[:location] = response['location']['city']
  		@results[:temp_f] = response['current_observation']['temp_f']
  		@results[:temp_c] = response['current_observation']['temp_c']
  		@results[:weather_icon] = response['current_observation']['icon_url']
  		@results[:weather_words] = response['current_observation']['weather'] 
  		@results[:forecast_link] = response['current_observation']['forecast_url']
  		@results[:real_feel] = response['current_observation']['feelslike_c']
    end
  rescue RestClient::ExceptionWithResponse => err
    redirect_back(fallback_location: root_path, alert: 'Unexcepted error')
  end
  

end
