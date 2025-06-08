class CatFactsService
  def get_page(page_num)
    path = "facts"
    query = {}
    query.store("page", page_num) if page_num
    JSON.parse base_request(path, query), symbolize_names: true
  end

  def base_request(path, query = {})
    base_url = "https://catfact.ninja/"
    response = HTTParty.get(base_url + path, query: query, format: :plain)
    if response.code != 200
      raise BadHttpCallError.new("CatFact API unreachable")
    end
    content = JSON.parse response, symbolize_names: true
    if content[:current_page] > content[:last_page]
      raise RequestedPageDoesNotExist.new("Requested page exceeds total pages in API")
    end
    response
  end
end
