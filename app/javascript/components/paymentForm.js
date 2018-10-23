function showPaymentForm(methodBtn) {
  const $paymentForm = document.getElementById("customer-form");
  methodBtn.classList.toggle("method-selected");
  $paymentForm.classList.remove("hidden");
  document.querySelector(".payment-methods").classList.add("hidden");
}

function addmethodBtnListener(methodBtn) {
  methodBtn.addEventListener("click", (event) => {
    showPaymentForm(event.currentTarget);
  })
}

document.addEventListener("DOMContentLoaded", () => {
  const $methodBtn = document.querySelector(".methods-pic-container");

  if($methodBtn) {
    addmethodBtnListener($methodBtn);
  }
})
