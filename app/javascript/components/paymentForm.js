import { addCardInputListener } from "./creditCardForm.js"

function showPaymentForm(methodBtn) {
  const $paymentForm = document.getElementById("customer-form");
  methodBtn.classList.toggle("method-selected");
  $paymentForm.classList.remove("hidden");
  document.querySelector(".payment-methods").classList.add("hidden");
  addCardInputListener();
}

function addmethodBtnListener(methodBtn) {
  methodBtn.addEventListener("click", (event) => {
    showPaymentForm(event.currentTarget);
  })
}

function toggleDisabledOnSubmitPaymentForm() {
  const cardNameValue = document.getElementById("card[name]").value;
  const cardNumberValid = document.getElementById("card[number]").dataset.numberValid;
  const cardNumberMonthValue = document.getElementById("card[exp_month]").value;
  const cardNumberYearValue = document.getElementById("card[exp_year]").value;
  const cardCvcValue = document.getElementById("card[cvc]").value;
  const cardDocTypeValue = document.getElementById("card[doc_type]").value;
  const cardDocNumberValue = document.getElementById("card[doc_number]").value
  const cardEmailValue = document.getElementById("card[email]").value

  const $paymentSubmit = document.getElementById("payment-details-submit");


  if(cardNameValue && cardNumberValid && cardNumberMonthValue && cardNumberYearValue && cardCvcValue  && cardDocTypeValue && cardDocNumberValue && cardEmailValue) {
    $paymentSubmit.removeAttribute("disabled");
  } else {
    $paymentSubmit.setAttribute("disabled", "true");
  }
}


document.addEventListener("DOMContentLoaded", () => {
  const $methodBtn = document.querySelector(".methods-pic-container");
  const $form = document.getElementById("customer-form");

  if($methodBtn) {
    addmethodBtnListener($methodBtn);
  }

  if ($form) {
    $form.addEventListener("keyup", (event) => { toggleDisabledOnSubmitPaymentForm() })
  }

})

