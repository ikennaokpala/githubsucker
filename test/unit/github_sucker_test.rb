require "minitest_helper"

class GitHubSuckerTest < MiniTest::Unit::TestCase
  def setup
    @dashboard = GitHubSucker::DashBoard
    @scrapper = GitHubSucker::Scrapper.new
  end

  def test_project_info_search
    search_result = @scrapper.project_info_search("nu").split("/")
    assert_equal "timburks", search_result.first
    assert_equal "nu", search_result[1]
  end

  def test_invalid_project_info_search
    search_result = @scrapper.project_info_search("timburks/nu")
    assert_empty search_result
  end

  def  test_page_doc
    @url = "#{BASE_URL}/search?type=Repositories&q=nu&repo=&langOverride=&x=14&y=9&start_value=1"
    assert_kind_of Nokogiri::XML::Document, @scrapper.send(:page_doc, @url)
  end

  def test_rank_octocats 
    octocats = @dashboard.rank_octocats("timburks/nu")
    assert_kind_of Enumerable, octocats
  end

  def test_octocats 
    octocats = @dashboard.octocats("nu")
    assert_kind_of Enumerable, octocats
  end

  def test_nil_project_name_octocats
    assert_raises(Octokit::NotFound) do
      @dashboard.octocats("timburks/nu")
    end
  end
end
