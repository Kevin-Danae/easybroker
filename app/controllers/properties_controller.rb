require "uri"
require "net/http"
require "json"

class PropertiesController < ApplicationController
  API_URL = "https://api.stagingeb.com/v1/properties?page=1&limit=20"
  AUTH_HEADER = "l7u502p8v46ba3ppgvj5y2aad50lb9"

  def index
    response = fetch_properties

    unless response.is_a?(Net::HTTPSuccess)
      render_error(response)
      return
    end

    render json: parse_titles(response)
  end

  def fetch_properties
    url = URI(API_URL)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = "application/json"
    request["X-Authorization"] = AUTH_HEADER

    http.request(request)
  end

  def render_error(response)
    error_message = JSON.parse(response.body)["error"]
    render json: { error: error_message }, status: response.code.to_i
  end

  def parse_titles(response)
    results = JSON.parse(response.body)["content"]
    results.map { |property| property["title"] }
  end
end
