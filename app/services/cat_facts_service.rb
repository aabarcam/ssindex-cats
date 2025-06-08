class CatFactsService
  def get_page(page_num)
    path = "facts"
    query = {}
    query.store("page", page_num) if page_num
    base_request(path, query)
  end

  def base_request(path, query = {})
    base_url = "https://catfact.ninja/"
    response = HTTParty.get(base_url + path, query: query)
    if response.code != 200
      raise BadHttpCallError.new("CatFact API unreachable")
    end
    response
  end
end
