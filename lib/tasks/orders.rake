namespace :orders do
  desc "Update all status of complete orders"
  task update_all_status: :environment do
    users = User.all
    users.each do |user|
      UpdateOrderStatusJob.perform_later(user.id)
    end
  end
end
