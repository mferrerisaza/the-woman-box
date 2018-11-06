import flatpickr from "flatpickr";
import "flatpickr/dist/flatpickr.min.css";
import { Spanish } from "flatpickr/dist/l10n/es.js"
import "flatpickr/dist/themes/airbnb.css";


const dateInput = flatpickr(".datepicker", {
  minDate: new Date().fp_incr(-40), // 40 days before today
  maxDate: "today",
  altInput: true,
  altFormat: "d M Y",
  dateFormat: "Y-m-d",
  "locale": Spanish,

});


