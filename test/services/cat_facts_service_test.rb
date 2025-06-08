require "test_helper"

class CatFactsServiceTest < ActiveSupport::TestCase
  test "should succeed on valid url" do
    dummy_fact = "some fact"
    stub_request(:get, "https://catfact.ninja/facts").
      to_return(body: { data: [ { fact: dummy_fact, length: dummy_fact.length } ], last_page: 34, current_page: 1 }.to_json, status: 200)
    response = CatFactsService.new.base_request("facts")
    assert_equal(200, response.code)
    content = JSON.parse response.body
    assert_equal(dummy_fact, content["data"][0]["fact"])
  end

  test "should error on invalid url" do
    stub_request(:get, "https://catfact.ninja/invalid").
      to_return(body: "Not Found", status: 404)
    error = assert_raises(BadHttpCallError) do
      CatFactsService.new.base_request("invalid")
    end
    assert_equal("CatFact API unreachable", error.message)
  end

  test "should error on max page exceeded" do
    path = "facts?page=100"
    stub_request(:get, "https://catfact.ninja/" + path).
      to_return(body: { data: [], last_page: 34, current_page: 100 }.to_json, status: 200)
    error = assert_raises(RequestedPageDoesNotExist) do
      CatFactsService.new.base_request(path)
    end
    assert_equal("Requested page exceeds total pages in API", error.message)
  end

  test "should return page one on non positive page" do
    path = "facts?page=0"
    stub_request(:get, "https://catfact.ninja/" + path).
      to_return(body: { data: [], last_page: 34, current_page: 1 }.to_json, status: 200)
    response = CatFactsService.new.base_request(path)
    content = JSON.parse response.body
    assert_equal(1, content["current_page"])
  end
end
