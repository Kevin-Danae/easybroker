require "test_helper"
require "webmock/minitest"

class PropertiesControllerTest < ActionDispatch::IntegrationTest
  API_URL = "https://api.stagingeb.com/v1/properties?page=1&limit=20"
  API_HEADERS = { "accept" => "application/json", "X-Authorization" => "l7u502p8v46ba3ppgvj5y2aad50lb9" }

  def stub_successful_response
    stub_request(:get, API_URL)
      .with(headers: API_HEADERS)
      .to_return(
        status: 200,
        body: {
          "content" => [
             { "title" => "Property 1", "public_id" => "1" },
             { "title" => "Property 2", "public_id" => "2" },
             { "title" => "Property 3", "public_id" => "3" }
          ]
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end

  def stub_error_response
    stub_request(:get, API_URL)
      .with(headers: API_HEADERS)
      .to_return(
        status: 400,
        body: { "error" => "Bad Request" }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end

  test "should_return_titles_from_api_response" do
    stub_successful_response

    get properties_url
    assert_response :success
    assert_equal ["Property 1", "Property 2", "Property 3"], JSON.parse(response.body)
  end

  test "should_handle_400_error_response_from_api" do
    stub_error_response

    get properties_url
    assert_response :bad_request
    assert_equal "Bad Request", JSON.parse(response.body)["error"]
  end
end
