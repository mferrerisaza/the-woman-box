var valid = require('card-validator');


function maskCardInput(cardInput, lengths) {

}

function validateCard(card) {
  const numberValidation = valid.number(card.value);

  // if (!numberValidation.isPotentiallyValid) {
  //   renderInvalidCardNumber();
  // }

  if (numberValidation.card) {
    maskCardInput(card, numberValidation.card.lengths); // 'visa'
  }
}

export function addCardInputListener(){
  const $cardInput = document.getElementById("card[number]");
  console.log("added");
  $cardInput.addEventListener("keyup", (event) => {
    validateCard(event.currentTarget);
  })
}

document.addEventListener("DOMContentLoaded", ()=> {
  const $cardInput = document.querySelector(".card[number]");

  if ($cardInput) {
    addCardInputListener();
  }
})
