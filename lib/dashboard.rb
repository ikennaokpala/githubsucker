require_relative "scrapper"
require "octokit"

module GitHubSucker 
  module DashBoard
    @@github_scrapper = GitHubSucker::Scrapper.new

    def self.cockpit(project_name)

      printf "%12s%18s%18s%18s%18s%18s%20s\n", "User", "Repos", "Own Projects", "Forked Projects", "Scala Projects","Ruby Projects", "Javascript Projects"
      octocats(project_name).each do |i|
        printf "%13s%14s%14s%14s%18s%18s%18s\n", i["name"], i["num_repos"], i["original"], i["forked"], i["scala_projects"],i["ruby_projects"], i["js_projects"]
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
      users = []
      Octokit.forks(project_name).each do |fk|
        user = Hash.new
        repositories = Octokit.repositories(fk.owner.login)
        user["name"] = fk.owner.login
        user["num_repos"] = repositories.size
        user["js_projects"] = repositories.map{|repo| repo.language && repo.language.downcase == "javascript" ? 1 : nil }.compact.size
        user ["scala_projects"] = repositories.map{|repo| repo.language && repo.language.downcase == "scala" ? 1 : nil }.compact.size
        user["ruby_projects"] =  repositories.map{|repo| repo.language && repo.language.downcase == "ruby"? 1 : nil}.compact.size
        user["forked"] = repositories.map{|repo| repo.fork ? 1 : nil}.compact.size
        user["original"] = repositories.map{|repo| !repo.fork ? 1 : nil}.compact.size

        users << user
      end
      users.sort_by!{|u| u["forked"]}.reverse!
    end 
  end
end


