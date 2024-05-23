document.addEventListener("DOMContentLoaded", function() {
    var colorSelect = document.querySelector("select[name='customize[calendar_color]']");
    
    colorSelect.addEventListener("change", function() {
      var selectedColor = this.value.toLowerCase();
      
      var calendarElement = document.querySelector(".simple-calendar");
      calendarElement.classList.remove("red", "blue", "green", "yellow");
      
      if (selectedColor !== "default") {
        calendarElement.classList.add(selectedColor);
      }
    });
  });
  