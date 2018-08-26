require "noun-project-api/connection"
module NounProjectApi
  # Retrieve icons.
  class IconsRetriever
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
      get_icons("/icons/#{term}#{query}")
    end

    def find_by_collection(slug_or_id, limit = nil, offset = nil, page = nil)
      fail(ArgumentError, "Missing search slug_or_id") unless slug_or_id

      args = {
        "limit" => limit,
        "offset" => offset,
        "page" => page
      }
      query = search_query(args)
      get_icons("/collection/#{slug_or_id}/icons#{query}")
    end

    # List recent uploads
    # * limit - limit the amount of results
    # * offset - offset the results
    # * page - page number
    def recent_uploads(limit = nil, offset = nil, page = nil)
      args = {
        "limit" => limit,
        "offset" => offset,
        "page" => page
      }

      query = search_query(args)
      get_icons("/icons/recent_uploads#{search}")
    end
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
      JSON.parse(result.body)["icons"].map { |icon| Icon.new(icon) }
    else
      []
    end

  end

end
