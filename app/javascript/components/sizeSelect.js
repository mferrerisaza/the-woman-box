var cloudinary = require('cloudinary');

cloudinary.config({
  cloud_name: 'dnf96fubu'
});

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
      <div class="col-xs-6">
        <div class="plan-card">
          <div class="plan-card-img" style="background-image: url('${planPictureOrGeneric(plan)}');"></div>
          <p>${ plan.name }</p>
        </div>
      </div>
    `
  }
  return text
}

function createPlanCards(plansData){
  const $plansCardsContainer = document.querySelector(".plan-cards-container").querySelector(".row");
  if (plansData === null) {
    $plansCardsContainer.innerHTML = "";
  } else {
    const text = createHTML(plansData)
    $plansCardsContainer.innerHTML = text;
    // $plansCardsContainer.insertAdjacentHTML("beforeend", text);
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
    getData(`/plans?size_id=${value}`, createPlanCards);
  })
}


document.addEventListener("DOMContentLoaded", () => {
  const $sizeSelect = document.getElementById("order_size");

  if ($sizeSelect) {
    addListenerToSizeSelect($sizeSelect);
  }
})
