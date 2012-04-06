require_relative "scrapper"
require "octokit"

module GitHubSucker 
  module DashBoard
    @@github_scrapper = GitHubSucker::Scrapper.new

    def self.cockpit(project_name)
      printf "%12s%18s%18s%18s%18s%18s%20s\n", "User", "Repos", "Own Projects", "Forked Projects", "Scala Projects","Ruby Projects", "Javascript Projects"
      octocats(project_name).each do |o|
        printf "%13s%14s%14s%14s%18s%18s%18s\n", o["name"], o["num_repos"], o["original"], o["forked"], o["scala_projects"], o["ruby_projects"], o["js_projects"]
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
      octocats  = []
      Octokit.forks(project_name).each do |fk|
        octocat = Hash.new
        repositories = Octokit.repositories(fk.owner.login)
        octocat["name"] = fk.owner.login
        octocat["num_repos"] = repositories.size
        octocat["js_projects"] = repositories.select{|repo| repo.language && repo.language.downcase == "javascript"}.size
        octocat ["scala_projects"] = repositories.select{|repo| repo.language && repo.language.downcase == "scala"}.size
        octocat["ruby_projects"] =  repositories.select{|repo| repo.language && repo.language.downcase == "ruby"}.size
        octocat["forked"] = repositories.select{|repo| repo.fork}.size
        octocat["original"] = repositories.select{|repo| !repo.fork}.size

        octocats << octocat
      end
      octocats.sort_by!{|u| u["forked"]}.reverse!
    end 
  end
end


