require "noun-project-api/icon"
require "noun-project-api/connection"

module NounProjectApi
  # Retrieve an icon.
  class IconRetriever
    include Connection
    ITEM_CLASS = Icon

    # Find an item based on it's id.
    def find(id)
      fail(ArgumentError, "Missing id/slug") unless id
      id = OAuth::Helper.escape(id)
      result = access_token.get("#{API_BASE}/icon/#{id}")
      fail(ArgumentError, "Bad request") unless result.code == "200"

      Icon.new(result.body)
    end

  end
end
