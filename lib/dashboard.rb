require_relative "scrapper"
require "octokit"

module GitHubSucker 
  module DashBoard
    @@github_scrapper = GitHubSucker::Scrapper.new

    def self.cockpit(project_name)

      printf "%12s%18s%18s%18s%20s\n", "User", "Own Projects", "Forked Projects", "Ruby Projects", "Javascript Projects"
      octocats(project_name).each do |i|
        printf "%13s%14s%14s%14s%14s\n", i["name"], i["original"], i["forked"], i["ruby_projects"], i["js_projects"]
      end
    end

    def self.octocats(project_name)      
      project = @@github_scrapper.project_info_search(project_name)      
      if project.nil? || project.empty?
        raise "Project does not exist! Try again!"
      else
        rank_octocats project
      end
    end

    private 
    def self.rank_octocats(project_name)
      users = Hash.new
      Octokit.forks(project_name).each do |fk|
        repositories = Octokit.repositories(fk.owner.login)
        users["name"] = fk.owner.login
        users["num_repos"] = repositories.size
        users["js_projects"] = repositories.map{|r| r.language && r.language.downcase == "javascript" ? 1 : nil }.compact.size
        users["ruby_projects"] = repositories.map{|r| r.language && r.language.downcase == "ruby"? 1 : nil}.compact.size
        users["forked"] = repositories.map{|r| r.fork ? 1 : nil}.compact.size
        users["original"] = repositories.map{|r| !r.fork ? 1 : nil}.compact.size
      end
      [users]#.sort_by!{|u| u["original"]}.reverse!
    end 
  end
end


