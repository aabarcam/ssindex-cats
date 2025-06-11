class CatFactsService
  def get_page(page_num)
    path = "facts"
    query = {}
    query.store("page", page_num) if page_num
    JSON.parse base_request(path, query), symbolize_names: true
  end

  # fetch only necessary pages
  def get_facts(id_array)
    if id_array.any? { |id| id < 1 }
      raise NonPositiveIdError.new("Non positive integer id found")
    end
    first_page = get_page 1
    page_size = first_page[:per_page]
    ids = sort_to_pages(id_array, page_size)
    facts = []
    ids.each do |page_num, page_ids|
      page = get_page page_num
      data = page[:data]
      data = attach_id_to_fact(data, page_num, page_size)
      filtered_data = data.filter { |fact| fact[:id].in? page_ids }
      facts = facts + filtered_data
    end
    facts
  end

  # attach id to fact correponding to index in current page
  def attach_id_to_fact(fact_array, page, page_size)
    fact_array.map { |el| { fact: el[:fact], id: fact_array.index(el) + (page - 1) * page_size + 1 } }
  end

  # compute pages the ids belong to
  def sort_to_pages(id_array, page_size)
    if page_size < 1
      raise NonPositivePageSizeError.new("Page of non positive size")
    end
    if page_size - page_size.floor != 0
      raise NonPositivePageSizeError.new("Page of non integer size")
    end
    page_size = page_size.to_f
    ids = id_array.sort
    remaining_ids = ids
    pages = {}
    while !remaining_ids.empty?
      next_id = remaining_ids.first
      next_page = (next_id/page_size).ceil
      page_ids = remaining_ids.filter { |id| id <= next_page * page_size && id > (next_page - 1) * page_size }
      remaining_ids = remaining_ids - page_ids
      pages[next_page] = page_ids
    end
    pages
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
