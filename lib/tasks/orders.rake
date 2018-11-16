namespace :orders do
  desc "Update all status of complete orders"
  task update_all_status: :environment do
    UpdateOrderStatusJob.perform_later
  end
end
