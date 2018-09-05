require "noun-project-api/collection"
require "noun-project-api/connection"

module NounProjectApi
  # Retrieve a collection.
  class CollectionsRetriever
    include Connection

    # Finds multiple icons based on the term
    # * term - search term
    # * limit - limit the amount of results
    # * offset - offset the results
    # * page - page number
    def find(term, limit = nil, offset = nil, page = nil)
      fail(ArgumentError, "Missing search term") unless term

      term = OAuth::Helper.escape(term)

      args = {
        "limit" => limit,
        "offset" => offset,
        "page" => page,
        "limit_to_public_domain" => NounProjectApi.configuration.public_domain ? 1 : 0
      }

      query = search_query(args)
      get_icons("/collections/#{term}#{query}")
    end

    private

    def search_query(args)
      args = args.reject { |_, v| v.nil? }
      search = ""
      if args.size > 0
        search = "?"
        args.each { |k, v| search += "#{k}=#{v}&" }
      end
      return search
    end

    def get_icons(api_path)
      result = access_token.get("#{API_BASE}#{api_path}")
      fail(ArgumentError, "Bad request") unless %w(200 404).include? result.code

      if result.code == "200"
        JSON.parse(result.body)["collections"].map { |collection| Collection.new(collection) }
      else
        []
      end

    end
  end
end
