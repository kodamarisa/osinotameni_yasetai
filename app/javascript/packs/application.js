// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "controllers"
import "./sidebar"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

document.addEventListener("DOMContentLoaded", () => {
    const modal = document.getElementById("schedule-modal");
    const span = document.getElementsByClassName("close")[0];
  
    document.querySelectorAll(".calendar-date").forEach(element => {
      element.addEventListener("click", (event) => {
        event.preventDefault();
        const date = event.currentTarget.dataset.date;
        fetch(`/schedules/new?date=${date}`)
          .then(response => response.text())
          .then(html => {
            document.getElementById("schedule-details").innerHTML = html;
            modal.style.display = "block";
          });
      });
    });
  
    span.onclick = function() {
      modal.style.display = "none";
    }
  
    window.onclick = function(event) {
      if (event.target == modal) {
        modal.style.display = "none";
      }
    }
  });
  