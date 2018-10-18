import { toggleDisabledOnSubmitPlanForm } from "./planSubmit.js"

 export function addSelectedClass(card, cards) {
  for (let i = 0; i < cards.length; i++) {
    cards[i].classList.remove("selected-card");
  }
  card.classList.add("selected-card");
}

 export function addPlanIdValue(planId) {
  const planIdValue = document.getElementById("order_plan_id");
  planIdValue.value = planId;
}

 export function addPlanCardsListener() {
  const $cards = document.querySelectorAll(".plan-card");
  for (let i = 0; i < $cards.length; i++) {
    $cards[i].addEventListener("click", (event) => {
      addSelectedClass(event.currentTarget, $cards);
      addPlanIdValue(event.currentTarget.dataset.planId);
      toggleDisabledOnSubmitPlanForm();
    })
  }
}

