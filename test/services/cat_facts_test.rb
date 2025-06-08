require "test_helper"

class CatFactsServiceTest < ActiveSupport::TestCase
  test "should succeed on valid url" do
    dummy_fact = "some fact"
    stub_request(:get, "https://catfact.ninja/facts").
      to_return(body: { data: [ { fact: dummy_fact, length: dummy_fact.length } ] }.to_json, status: 200)
    response = CatFacts.new.base_request("facts")
    assert_equal(200, response.code)
    content = JSON.parse response.body
    assert_equal(dummy_fact, content["data"][0]["fact"])
  end
  test "should error on invalid url" do
    stub_request(:get, "https://catfact.ninja/invalid").
      to_return(body: "Not Found", status: 404)
    error = assert_raises(BadHttpCallError) do
      CatFacts.new.base_request("invalid")
    end
    assert_equal("CatFact API unreachable", error.message)
  end
end
