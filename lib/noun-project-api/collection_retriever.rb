require "noun-project-api/collection"
require "noun-project-api/connection"

module NounProjectApi
  # Retrieve a collection.
  class CollectionRetriever
    include Connection

    # Find an item based on it's id.
    def find(id)
      fail(ArgumentError, "Missing id/slug") unless id

      result = access_token.get("#{API_BASE}/collection/#{id}")
      fail(ArgumentError, "Bad request") unless result.code == "200"

      Collection.new(result.body)
    end
    
  end
end
