function autocomplete(orderAddress) {
  if (orderAddress) {
    const autocomplete = new google.maps.places.Autocomplete(orderAddress, { types: [ 'geocode' ] });
    google.maps.event.addListener(autocomplete, 'place_changed', onPlaceChanged);
    google.maps.event.addDomListener(orderAddress, 'keydown', function(e) {
      if (e.key === "Enter") {
        e.preventDefault(); // Do not submit the form on Enter.
      }
    });
  }
}

document.addEventListener("DOMContentLoaded", function() {
  const $orderAddress = document.getElementById('order[address]');
  if ($orderAddress) {
    autocomplete($orderAddress)
  }
});


function onPlaceChanged() {
  var place = this.getPlace();
  var components = getAddressComponents(place);
  var $orderAddress = document.getElementById('order[address]');
  $orderAddress.blur();
  $orderAddress.value = components.address;

  document.getElementById('order[province]').value = components.province;
  document.getElementById('order[city]').value = components.city;

  if (components.country_code) {
    document.getElementById("order[country]").querySelector('option[value="' + components.country_code + '"]').selected = true;
  }
}

function getAddressComponents(place) {

  if (window.console && typeof console.log === "function") {
    console.log(place);
  }

  var street_number = null;
  var route = null;
  var zip_code = null;
  var city = null;
  var province = null;
  var country_code = null;
  for (var i in place.address_components) {
    var component = place.address_components[i];
    for (var j in component.types) {
      var type = component.types[j];
      if (type === 'street_number') {
        street_number = component.long_name;
      } else if (type === 'route') {
        route = component.long_name;
      } else if (type === 'postal_code') {
        zip_code = component.long_name;
      } else if (type === 'locality') {
        city = component.long_name;
      } else if (type === 'administrative_area_level_1') {
        province = component.long_name;
      } else if (type === 'country') {
        country_code = component.short_name;
      }
    }
  }

  return {
    address: street_number === null ? route : (route + ' ' + street_number),
    zip_code: zip_code,
    province, province,
    city: city,
    country_code: country_code
  };
}
