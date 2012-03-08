require "minitest_helper"

class GitHubSuckerTest < MiniTest::Unit::TestCase
  def setup
    @dashboard = GitHubSucker::DashBoard
    @scrapper = GitHubSucker::Scrapper.new
    @url = "#{BASE_URL}/search?type=Repositories&q=nu&repo=&langOverride=&x=14&y=9&start_value=1"
  end
  def test_project_info_search
    search_result = @scrapper.project_info_search("nu").split("/")
    assert_equal "timburks", search_result.first
    assert_equal "nu", search_result[1]
  end

  def  test_page_doc
     assert_kind_of Nokogiri::XML::Document, @scrapper.send(:page_doc, @url)
  end
end
