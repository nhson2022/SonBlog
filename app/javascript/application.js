// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// Setup jquery
import jquery from 'jquery';
window.jQuery = jquery;
window.$ = jquery;

import Select2 from "select2"
window.Select2 = Select2
Select2()

// load select2
document.addEventListener('turbo:load', () => {
  // apply to all elements that have class .select2
  $('.select2').select2()
})
import "trix"
import "@rails/actiontext"

// app/javascript/application.js
Turbo.setConfirmMethod((message, element) => {
  console.log(message, element)
  let dialog = document.getElementById("turbo-confirm")
  dialog.querySelector("p").textContent = message
  dialog.showModal()

  return new Promise((resolve, reject) => {
    dialog.addEventListener("close", () => {
      resolve(dialog.returnValue == "confirm")
    }, { once: true })
  })
})