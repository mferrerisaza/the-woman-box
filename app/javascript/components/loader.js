function addListenerToPaymentFormSubmit(form) {
  const $paymentFormBtn = document.getElementById("payment-details-submit");
  const $loader = document.querySelector(".loader-div");

  form.addEventListener("submit", (event) => {
   $paymentFormBtn.setAttribute("disabled", "true");
   $loader.style.visibility = "visible";
  })
}

document.addEventListener("DOMContentLoaded", () => {
  const $form = document.getElementById("customer-form");

  if ($form){
    addListenerToPaymentFormSubmit($form)
  }
})
