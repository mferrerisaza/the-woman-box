var cloudinary = require('cloudinary');

cloudinary.config({
  cloud_name: 'dnf96fubu'
});

import { addPlanCardsListener } from "./planCards.js"

function planPictureOrGeneric(plan) {
  let url = ""
  if(plan.photo.url !== null) {
    url = plan.photo.url
  } else {
    url = "Default Pics/fieldplaceholder.jpg"
  }
  return cloudinary.url(url, { effect: "blackwhite", height: 200, width: 200, crop: "fit" })
}

function createHTML(plansData){
  let text = "";
  for (let i = 0; i < plansData.length; i++) {
    let plan = plansData[i];
    text +=
    `
      <div class="plan-card" data-plan-id="${plan.id}">
        <div class="plan-card-img" style="background-image: url('${planPictureOrGeneric(plan)}');"></div>
        <p>${ plan.name }</p>
      </div>
    `
  }
  return text
}

function createPlanCards(plansData){
  const $plansCardsContainer = document.querySelector(".plan-cards-container");
  const $brandLabel = document.getElementById("brand_label");

  if (plansData === null) {
    $plansCardsContainer.innerHTML = "";
    $brandLabel.classList.add("hidden");

  } else {
    const text = createHTML(plansData)
    $brandLabel.classList.remove("hidden");
    $plansCardsContainer.innerHTML = text;
    addPlanCardsListener();
  }
}

function getData(url, callback){
  fetch(url)
  .then(response => response.json())
  .then((data) => {
    callback(data)
  });
}

function addListenerToSizeSelect(select) {
  select.addEventListener("change", (event) => {
    const value = event.currentTarget.value;
    const planTypeParam = new URLSearchParams(document.location.search).get("plan_type")
    if (planTypeParam) {
      getData(`/plans?size_id=${value}&plan_type=${planTypeParam}`, createPlanCards);
    } else {
      getData(`/plans?size_id=${value}`, createPlanCards);
    }
  })
}


document.addEventListener("DOMContentLoaded", () => {
  const $sizeSelect = document.getElementById("order_size");

  if ($sizeSelect) {
    addListenerToSizeSelect($sizeSelect);
  }
})
