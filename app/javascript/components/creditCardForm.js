var valid = require('card-validator');
var numberValidation = valid.number('4111');

if (!numberValidation.isPotentiallyValid) {
  renderInvalidCardNumber();
}

if (numberValidation.card) {
  console.log(numberValidation); // 'visa'
}

document.addEventListener("DOMContentLoaded", ()=> {

})
