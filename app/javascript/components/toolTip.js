  function addListenerToTooltip(tooltip){
    tooltip.addEventListener("click", (event) => {
      event.preventDefault();
      $('.no-follow').tooltip('toggle');
    });
  }
document.addEventListener("DOMContentLoaded", () =>  {
  $(function () {
    $('[data-toggle="tooltip"]').tooltip()
  })
  const $tooltipBtn = document.querySelector(".no-follow");
  if ($tooltipBtn) {
    addListenerToTooltip($tooltipBtn);
  }
})
