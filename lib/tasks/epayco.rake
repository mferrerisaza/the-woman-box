namespace :epayco do
  desc "delete all plans that do have active subscriptions on epayco account"
  task delete_all_plans: :environment do
    epayco_call = Epayco::Plan.list
    plans = epayco_call[:data]
    plans.each do |plan|
      Epayco::Plan.delete plan[:id_plan]
    end
  end

  desc "cancel all subscriptions on epayco account"
  task cancel_all_subscriptions: :environment do
    epayco_call = Epayco::Subscriptions.list
    subscriptions = epayco_call[:data]
    subscriptions.each do |subscription|
      Epayco::Subscriptions.cancel subscription[:_id]
    end
  end
end
