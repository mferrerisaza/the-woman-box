import Cleave from "cleave.js";

var valid = require('card-validator');

var cloudinary = require('cloudinary');

cloudinary.config({
  cloud_name: 'dnf96fubu'
});


function renderBrandPic(brand) {
  if (brand === "visa"){
    return "the-woman-box/visa.png"
  } else if (brand === "american-express") {
    return "the-woman-box/amex.png"
  } else if (brand === "mastercard") {
    return "the-woman-box/master_card.png"
  } else if (brand === "diners-club") {
    return "the-woman-box/diners.png"
  } else {
    return "the-woman-box/disable.png"
  }
}

function validateCard(card) {
  const numberValidation = valid.number(card.value);
  const $cardPicture = document.querySelector(".card-brand-picture");
  const cardType = numberValidation.card;

  if (!numberValidation.isPotentiallyValid) {
    card.parentNode.classList.add("invalid-card")
  } else {
    card.parentNode.classList.remove("invalid-card")
    if (cardType){
      const brandPic = renderBrandPic(cardType.type);
      $cardPicture.setAttribute("src", cloudinary.url(brandPic));
    } else {
      $cardPicture.setAttribute("src", cloudinary.url("the-woman-box/disable.png"));
    }
  }

  if (numberValidation.isValid) {
    card.dataset.numberValid = "true";
  } else {
    delete card.dataset.numberValid;
  }
}

export function addCardInputListener(){
  const $cardInput = document.getElementById("card[number]");
  $cardInput.addEventListener("keyup", (event) => {
    validateCard(event.currentTarget);
  })
}

document.addEventListener("DOMContentLoaded", ()=> {
  const $cardInput = document.getElementById("card[number]");
  const $cvcInput = document.getElementById("card[cvc]")

  if ($cardInput && $cvcInput) {
    const cleave = new Cleave('.credit-card', { creditCard: true });
    const cvc = new Cleave('.credit-card-cvc', { blocks: [6], numericOnly: true })
    const date = new Cleave('.credit-card-date', { blocks: [6], numericOnly: true })
  }
})
