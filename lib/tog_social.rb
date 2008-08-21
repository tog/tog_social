namespace :tog do
  namespace :update do
    desc "Update the tog plugins on this app"
    task :plugins do
      deps = %w(tog_core tog_mail tog_user tog_social)
      require 'rubygems'
      require 'rubygems/gem_runner'
      Gem.manage_gems

      rails = (version = ENV['VERSION']) ?
        Gem.cache.find_name('rails', "= #{version}").first :
        Gem.cache.find_name('rails').sort_by { |g| g.version }.last

      version ||= rails.version

      unless rails
        puts "No rails gem #{version} is installed.  Do 'gem list rails' to see what you have available."
        exit
      end

      puts "Updating the tog plugins in your vendor/plugins directory"
      rm_rf   "vendor/rails"
      mkdir_p "vendor/rails"

      begin
        chdir("vendor/plugins") do
          rails.dependencies.select { |g| deps.include? g.name }.each do |g|
            Gem::GemRunner.new.run(["unpack", g.name, "--version", g.version_requirements.to_s])
            mv(Dir.glob("#{g.name}*").first, g.name)
          end

          Gem::GemRunner.new.run(["unpack", "rails", "--version", "=#{version}"])
          FileUtils.mv(Dir.glob("rails*").first, "railties")
        end
      rescue Exception
        rm_rf "vendor/rails"
        raise
      end
    end
  end
end 