namespace :pf do
  task :init => :environment do
    require File.join(Rails.root, "config", "page_fragments")
  end
end