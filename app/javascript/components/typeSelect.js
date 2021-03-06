function createHTML(sizesData){
  let text = "";
  for (let i = 0; i < sizesData.length; i++) {
    text += `<option value="${sizesData[i].id}">${sizesData[i].name}</option>`
  }
  return text
}

function toggleSizeSelect(sizesData){
  const $sizeSelect = document.getElementById("order_size");
  const $sizeSelectLabel = document.getElementById("size_select_label");
  const $plansCardsContainer = document.querySelector(".plan-cards-container");
  const $brandLabel = document.getElementById("brand_label");

  if (sizesData === null) {
    $sizeSelect.classList.add("hidden");
    $sizeSelectLabel.classList.add("hidden");
    $brandLabel.classList.add("hidden");
    $plansCardsContainer.innerHTML = "";
  } else {
    $brandLabel.classList.add("hidden");
    $sizeSelect.classList.remove("hidden");
    $sizeSelectLabel.classList.remove("hidden");
    $plansCardsContainer.innerHTML = "";

    const text = `<option value="">Seleccionar</option>${createHTML(sizesData)}`

    $sizeSelect.innerHTML = text;
  }
}

function getData(url, callback){
  fetch(url)
  .then(response => response.json())
  .then((data) => {
    callback(data)
  });
}

function addListenerToTypeSelect(select) {
  select.addEventListener("change", (event) => {
    const value = event.currentTarget.value;
    getData(`/sizes?type_id=${value}`, toggleSizeSelect);
  })
}


document.addEventListener("DOMContentLoaded", () => {
  const $typeSelect = document.getElementById("order_type_id");

  if ($typeSelect) {
    addListenerToTypeSelect($typeSelect);
  }
})
