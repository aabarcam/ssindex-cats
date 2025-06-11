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
      CatFactsService.new.get_page(100)
    end
    assert_equal("Requested page exceeds total pages in API", error.message)
  end

  test "should return page one on non positive page" do
    path = "facts?page=0"
    stub_request(:get, "https://catfact.ninja/" + path).
      to_return(body: { data: [], last_page: 34, current_page: 1 }.to_json, status: 200)
    response = CatFactsService.new.get_page(0)
    assert_equal(1, response[:current_page])
  end

  test "sort pages should sort correctly" do
    id_array = [ 12, 2, 4, 14, 17, 5 ]
    page_size = 5
    expected = { 1 => [ 2, 4, 5 ], 3 => [ 12, 14 ], 4 => [ 17 ] }
    result = CatFactsService.new.sort_to_pages(id_array, page_size)
    assert_equal(expected, result)
  end

  test "sort pages should not error on empty array" do
    id_array = []
    page_size = 5
    assert_nothing_raised do
      result = CatFactsService.new.sort_to_pages(id_array, page_size)
      assert_empty result
    end
  end

  test "sort pages should not allow non positive page" do
    id_array = [ 12, 2, 4, 14, 17 ]
    page_size = 0
    error = assert_raises(NonPositivePageSizeError) do
      CatFactsService.new.sort_to_pages(id_array, page_size)
    end
    assert_equal("Page of non positive size", error.message)
  end

  test "sort pages should not allow float sized page" do
    id_array = [ 12, 2, 4, 14, 17 ]
    page_size = 1.4
    error = assert_raises(NonPositivePageSizeError) do
      CatFactsService.new.sort_to_pages(id_array, page_size)
    end
    assert_equal("Page of non integer size", error.message)
  end

  test "get facts should deliver necessary facts" do
    path = "facts"
    data_first_page = [ { fact: "first" }, { fact: "second" } ]
    data_second_page = [ { fact: "2->first" },
                        { fact: "2->second" },
                        { fact: "2->third" } ]
    stub_request(:get, "https://catfact.ninja/" + path).
      with(query: { page: 1 }).
      to_return(body: { data: data_first_page,
                        last_page: 34,
                        current_page: 1,
                        per_page: 10 }.to_json, status: 200)
    stub_request(:get, "https://catfact.ninja/" + path).
      with(query: { page: 2 }).
      to_return(body: { data: data_second_page,
                        last_page: 34,
                        current_page: 2,
                        per_page: 10 }.to_json, status: 200)
    id_array = [ 2, 13 ]
    result = CatFactsService.new.get_facts(id_array)
    expected = [ { fact: "second", id: 2 }, { fact: "2->third", id: 13 } ]
    assert_equal(expected, result)
  end

  test "get empty facts should not error" do
    path = "facts"
    stub_request(:get, "https://catfact.ninja/" + path).
      with(query: { page: 1 }).
      to_return(body: { data: [],
                        last_page: 34,
                        current_page: 1,
                        per_page: 10 }.to_json, status: 200)
    id_array = []
    result = CatFactsService.new.get_facts(id_array)
    assert_empty result
  end

  test "get negative id fact should error" do
    path = "facts"
    stub_request(:get, "https://catfact.ninja/" + path).
      with(query: { page: 1 }).
      to_return(body: { data: [],
                        last_page: 34,
                        current_page: 1,
                        per_page: 10 }.to_json, status: 200)
    id_array = [ -1, 4, 6 ]
    error = assert_raises(NonPositiveIdError) do
      CatFactsService.new.get_facts(id_array)
    end
    assert_equal("Non positive integer id found", error.message)
  end

  test "correct ids should be attached" do
    data = [ { fact: "fact1" },
              { fact: "fact2" },
              { fact: "fact3" } ]
    page_size = 3
    page = 2
    result = CatFactsService.new.attach_id_to_fact(data, page, page_size)
    expected = [ { fact: "fact1", id: 4 },
                  { fact: "fact2", id: 5 },
                  { fact: "fact3", id: 6 } ]
    assert_equal(expected, result)
  end

  test "attach id should not error on empty" do
    page_size = 2
    page = 2
    assert_nothing_raised do
      result = CatFactsService.new.attach_id_to_fact({}, page, page_size)
      assert_empty result
    end
  end
end
