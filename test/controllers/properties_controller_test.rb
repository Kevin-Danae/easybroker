require "test_helper"
require "webmock/minitest"

class PropertiesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @url = "https://api.stagingeb.com/v1/properties?page=1&limit=20"
  end

  test "should return titles from API response" do
    # Simular la respuesta de la API con WebMock
    stub_request(:get, @url)
      .with(headers: { "accept" => "application/json", "X-Authorization" => "l7u502p8v46ba3ppgvj5y2aad50lb9" })
      .to_return(
        status: 200,
        body: {
          "content" => [
            { "title" => "Property 1", "public_id" => "1" },
            { "title" => "Property 2", "public_id" => "2" },
            { "title" => "Property 3", "public_id" => "3" }
          ]
        }.to_json,
        headers: { "Content-Type" => "application/json"  }
      )

    get properties_url # Ruta para la acción `index`

    # Verificar que la respuesta es correcta
    assert_response :success
    assert_equal [ "Property 1", "Property 2", "Property 3" ], JSON.parse(response.body)
  end

  test "should handle 400 error response from API" do
    # Simular una respuesta de error 400 de la API con WebMock
    stub_request(:get, @url)
      .with(headers: { "accept" => "application/json", "X-Authorization" => "l7u502p8v46ba3ppgvj5y2aad50lb9" })
      .to_return(
        status: 400,
        body: { "error" => "Bad Request" }.to_json,
        headers: { "Content-Type" => "application/json" }
      )

    get properties_url # Ruta para la acción `index`

    # Verificar que la respuesta del controlador es correcta cuando ocurre un error
    assert_response :bad_request
    assert_equal "Bad Request", JSON.parse(response.body)["error"]
  end
end
