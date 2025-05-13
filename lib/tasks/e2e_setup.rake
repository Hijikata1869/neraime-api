namespace :e2e do
    desc "E2E用データの準備"
    task prepare: :environment do
        Rake::Task["db:drop"].invoke
        Rake::Task["db:create"].invoke
        Rake::Task["db:schema:load"].invoke
        Rake::Task["db:e2e_seed"].invoke
    end
end