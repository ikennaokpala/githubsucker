require_relative "scrapper"
require "octokit"

module GitHubSucker 
  module DashBoard
    @@git = GitHubSucker::Scrapper.new

    def self.cockpit(project_name)

      printf "%12s%18s%18s%18s%20s\n", "User", "Own Projects", "Forked Projects", "Ruby Projects", "Javascript Projects"
      octocats(project_name).each do |i|
        printf "%13s%14d%14d%14d%14d\n", i[:name], i[:original], i[:forked], i[:ruby_projects], i[:js_projects]
      end
    end

    def self.octocats(project_name)      
      project = @@git.project_info_search(project_name)      
      if project_name.nil?
        puts red_alert "Project does not exist! Try again!"
      else
        rank_octocats project
      end
    end

    private 
    def self.rank_octocats(project_name)
      users = []
      Octokit.forks(project_name).each do |fk|
        # look up the forked owner
        # init this crap
        js_projects = 0
        ruby_projects = 0
        original = 0
        forked = 0
        repositories = Octokit.repositories(fk.owner.login)
        repositories.each do |repo|

          repo.language && repo.language.downcase == 'ruby' ? ruby_projects = ruby_projects + 1 : repo.language && repo.language.downcase == 'javascript' ? js_projects = js_projects + 1 : nil

          repo.fork ? forked = forked + 1 : original = original + 1
        end

        users << {:name => fk.owner.login, :num_repos => repositories.size, :js_projects => js_projects, :ruby_projects => ruby_projects, :forked => forked, :original => original}

      end
      #puts users
      users.sort_by!{|u| :original}.reverse!
    end 
  end
end

