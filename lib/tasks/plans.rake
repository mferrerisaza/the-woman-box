namespace :plans do
  desc "Add billing_type to existing monthly subscription plans"
  task update_billing_type: :environment do
    plans = Plan.all
    plans.each do |plan|
      plan.update(billing_type: "Recurrente")
    end
  end
end
