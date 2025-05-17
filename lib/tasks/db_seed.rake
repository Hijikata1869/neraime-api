namespace :db do
  desc "E2Eテスト用のseedを読み込む"
  task e2e_seed: :environment do
    load(Rails.root.join('db', 'seeds', 'e2e.rb'))
  end
end