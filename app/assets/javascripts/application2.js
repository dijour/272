// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require materialize-sprockets
//= require materialize-form
//= require highcharts
//= require chartkick
//= require best_in_place
//= require vue 
//= require_tree .

$( document ).ready(function(){
  $(".button-collapse").sideNav();
});

$(document).ready(function(){
$('.slider').slider();
});

// $( document ).ready(function () {
//     $('.sidenav').sidenav();
//     $('select').material_select();
//     $('.datepicker').pickadate({
//     format: 'mmmm dd, yyyy',
//     formatSubmit: 'mmmm dd, yyyy',
//     selectMonths: true, // Creates a dropdown to control month
//     selectYears: 15, // Creates a dropdown of 15 years to control year,
//     today: 'Today',
//     clear: 'Clear',
//     close: 'Ok',
//     closeOnSelect: false // Close upon selecting a date,
//   });
// });
        
