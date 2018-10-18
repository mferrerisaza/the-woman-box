export function toggleDisabledOnSubmitPlanForm() {
  const typeValue = document.getElementById("order_type_id").value;
  const sizeValue = document.getElementById("order_size").value;
  const planIdValue = document.getElementById("order_plan_id").value;
  const $planSubmit = document.getElementById("plan-selection-submit");

  if(typeValue && sizeValue && planIdValue) {
    $planSubmit.removeAttribute("disabled");
  } else {
    $planSubmit.setAttribute("disabled", "true");
  }
}

document.addEventListener("DOMContentLoaded", () => {
  const $form = document.querySelector(".plan-form");

  if ($form) {
    $form.addEventListener("change", (event) => { toggleDisabledOnSubmitPlanForm() })
  }
})
