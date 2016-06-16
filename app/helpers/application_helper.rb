module ApplicationHelper
  class HashObject
    def initialize(hash={})
      @hash = hash
    end

    def method_missing(sym, *args, &block)
      @hash[sym]
    end
  end

  def form_for_hash(hash, name, url, html_options={}, &proc)
    object = HashObject.new(hash)
    form_for object, :as=>name, :url=>url, :html=>html_options, &proc
  end
end
