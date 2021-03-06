require 'curb'
require 'nokogiri'

BASE_URL = "https://github.com"

module GitHubSucker
  class Scrapper
    def initialize
      @browser = Curl::Easy.new
    end

    def project_info_search(repo_name)
      begin
        url = "#{BASE_URL}/search?type=Repositories&q=#{repo_name}&repo=&langOverride=&x=14&y=9&start_value=1"
        result = page_doc(url).search("//div[@id='code_search_results']/div[@class='results_and_sidebar']/div[@class='results']/div[1]/h2/a").inner_html.gsub(" ", "")
        return result 
      rescue => e
      end
    end
    
    private
      def page_doc(url)
        @browser.url = url 
        @browser.perform
        Nokogiri::HTML(@browser.body_str)
      end   
  end
end
