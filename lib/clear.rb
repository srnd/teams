class Clear
  require 'rest_client'
  @@clear_base = "https://clear.codeday.org"
  @@api_base = @@clear_base + "/api/"

  @@cache = {
    :region => { }
  }

  def initialize(token = "", secret = "")
    @token = token
    @secret = secret
  end

  def promotion_path(promotion)
    "#{@@clear_base}/event/#{promotion.event_id}/promotions/uses?code=#{promotion.clear_id}"
  end

  def get(path, params = {})
    params[:public] = @token
		params[:private] = @secret
		begin
			RestClient.get(@@api_base + path, {:params => params})
		rescue => e
			nil
		end
	end

  def post(path, params = {})
    params[:public] = @token
		params[:private] = @secret
		begin
			RestClient.post(@@api_base + path, JSON[params], :content_type => "application/json")
		rescue => e
			nil
		end
  end

  def get_promotion(id)
    res = get("promotion/#{id}")
		res.is_a?(String) ? JSON.parse(res) : nil
  end

  def new_promotion(code, username, percent, notes, event_id)
    res = post("promotions/new", {:code => code, :username => username, :percent => percent, :notes => notes, :event => event_id})
    res.is_a?(String) ? JSON.parse(res) : nil
  end

  def delete_promotion(id)
    res = post("promotions/delete", {:id => id})
    res.is_a?(String) ? JSON.parse(res) : nil
  end

  def get_events_volunteered_for(username)
    res = get("events/volunteered-for", { :username => username })
    res.is_a?(String) ? JSON.parse(res) : nil
  end

  def get_regions
    res = get("regions")
    res.is_a?(String) ? JSON.parse(res) : nil
  end

  def get_region(id)
    if @@cache[:region][id]
      @@cache[:region][id]
    else
      res = get("region/#{id}")
      @@cache[:region][id] = res.is_a?(String) ? JSON.parse(res) : nil
      res.is_a?(String) ? JSON.parse(res) : nil
    end
  end

  def get_batches
    res = get("batches")
    res.is_a?(String) ? JSON.parse(res) : nil
  end

  def get_events
    res = get("events")
    res.is_a?(String) ? JSON.parse(res) : nil
  end

  def get_event(id)
    res = get("event/#{id}")
    res.is_a?(String) ? JSON.parse(res) : nil
  end

  def get_registration(id)
    res = get("registration", {:registration => id})
    res.is_a?(String) ? JSON.parse(res) : nil
  end

  def get_registration_by_email(email)
    res = get("registration/by-email/#{email}")
    res.is_a?(String) ? JSON.parse(res) : nil
  end
end
