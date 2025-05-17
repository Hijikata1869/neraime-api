namespace :e2e do
    desc "E2E用データの準備"
    task prepare: :environment do
        Rake::Task["db:create"].invoke
        Rake::Task["db:schema:load"].invoke
        Rake::Task["db:truncate_all"]
        Rake::Task["db:e2e_seed"].invoke
    end
end