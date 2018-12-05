require 'rails_helper'

RSpec.feature "Subscriptions", type: :feature do
  after do
    begin
      Epayco::Subscriptions.cancel JSON.parse(Order.last.payment)["subscription"]["_id"]
      Epayco::Plan.delete Order.last.plan_sku
    rescue Epayco::Error => e
      puts e
    end
  end

  scenario "user subscribes succesfully (from banner to order summary)", js: true do
    data_setup
    click_landing_call_to_action
    select_subscription_plan
    create_account
    fill_delivery_details
    fill_payment_details
  end

  private

  def data_setup
    @type = FactoryBot.create(:type)
    @size = FactoryBot.create(:size, type: @type)
    @plan = FactoryBot.create(:plan, size: @size)
    @user = FactoryBot.build(:user)
  end

  def click_landing_call_to_action
    visit root_path
    within ".banner" do
      expect(page).to have_content "SUSCRÍBETE"
      click_link "Suscríbete"
    end
    aggregate_failures do
      expect(page).to have_css ".order-description"
      expect(page).to have_select "order[type_id]"
      expect(page).to have_button('Siguiente', disabled: true)
    end
  end

  def select_subscription_plan
    select @type.name, from: "Seleccionar tipo:"
    aggregate_failures do
      expect(page).to have_select "order[size]"
      expect(page).to_not have_css ".plan-card"
    end
    expect(page).to have_button('Siguiente', disabled: true)
    select @size.name, from: "Seleccionar tamaño:"
    expect(page).to_not have_css "plan-card"
    find("[data-plan-id = '#{@plan.id}']").click
    expect(page).to have_button('Siguiente', disabled: false)
    expect(page).to have_css ".plan-cards-container > .plan-card.selected-card"
    click_button 'Siguiente'
  end

  def create_account
    expect(page).to have_css("#new_user")
    active_tab = find(".active-number > .num").text
    expect(active_tab).to eq "2"
    fill_in "Tu nombre", with: @user.first_name
    fill_in "Tus apellidos", with: @user.last_name
    fill_in "Tu teléfono de contacto", with: @user.phone
    fill_in "Tu cuenta de correo", with: @user.email
    fill_in "Una contraseña", with: @user.password
    fill_in "Porfavor confirma tu contraseña", with: @user.password
    expect do
      click_button 'Siguiente'
    end.to change(User, :count).by 1
    expect(User.last.orders.size).to eq 1
  end

  def fill_delivery_details
    expect(page).to have_css(".edit_order")
    active_tab = find(".active-number > .num").text
    expect(active_tab).to eq "3"
    expect(page).to have_content("Bienvenida! Te has registrado correctamente")
    fill_in "Dirección de entrega", with: "Calle 11a # 42-18"
    expect(page).to have_css(".pac-container")
    find(".pac-item", match: :first).click
    expect(page).to have_field("Departamento / Provincia", with: "Antioquia")
    expect(page).to have_field("Ciudad", with: "Medellín")
    fill_in "Información adicional", with: "Edificio el Recinto Apto 302"
    find("input[placeholder='Ej: 10 Nov 2018']").click
    expect(page).to have_css(".flatpickr-calendar.open")
    find(".flatpickr-day.today").click
    click_button 'Siguiente'
    aggregate_failures do
      order = Order.last
      expect(order.address).to eq "Calle 11a 4218"
      expect(order.last_period).to eq Date.today.to_s
    end
  end

  def fill_payment_details
    expect(page).to have_css(".payment-methods")
    active_tab = find(".active-number > .num").text
    expect(active_tab).to eq "4"
    find(".methods-pic-container").click
    expect(page).to_not have_css(".payment-methods")
    expect(page).to have_css("#customer-form")
    aggregate_failures do
      expect(page).to have_field("Nombre como aparece en tarjeta", with: @user.full_name)
      expect(page).to have_field("Tipo de ID", with: "CC")
      expect(page).to have_field("Correo Electrónico", with: @user.email)
      expect(page).to have_button('Iniciar Suscripción', disabled: true)
    end
    fill_in "Número de tarjeta de crédito", with: "4575623182290326"
    fill_in "Fecha de expiración", with: "12"
    fill_in "card[exp_year]", with: "2018"
    fill_in "CVC", with: "123"
    fill_in "Número de documento", with: "1040182869"
    expect(page).to have_button('Iniciar Suscripción', disabled: false)
    create_epayco_plan
    click_button('Iniciar Suscripción')
    expect(Order.last.status).to eq "Pagada"
  end

  def create_epayco_plan
    plan_info = {
      id_plan: @plan.sku,
      name: @plan.name,
      description: @plan.description,
      amount: @plan.price.to_i,
      currency: "cop",
      interval: "month",
      interval_count: 1,
      trial_days: 0
    }

    begin
      Epayco::Plan.create plan_info
    rescue Epayco::Error => e
      puts e
    end
  end
end
