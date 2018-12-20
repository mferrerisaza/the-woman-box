function showModal(){
  $('#referralModal').modal('show')
}

document.addEventListener("DOMContentLoaded", () => {
  $modal = document.getElementById("referralModal")
  if ($modal) {
    window.setTimeout(showModal, 20000);
  }
})

