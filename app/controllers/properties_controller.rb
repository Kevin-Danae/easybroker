require "uri"
require "net/http"
require "json"

class PropertiesController < ApplicationController
  def index
    url = URI("https://api.stagingeb.com/v1/properties?page=1&limit=20")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = "application/json"
    request["X-Authorization"] = "l7u502p8v46ba3ppgvj5y2aad50lb9"

    response = http.request(request)

    if !response.is_a?(Net::HTTPSuccess)
      render json: response.value
    end

    titleProperties = titleMap(response)
    render json: titleProperties
  end

  private
  def titleMap(response)
    result = JSON.parse(response.body)["content"]
    titleProperties = result.map { |property| property["title"] }

    titleProperties
  end
end
