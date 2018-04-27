////////////////////////////////////////////////
//// Setting up a general ajax method to handle
//// transfer of data between client and server
////////////////////////////////////////////////
function run_ajax(method, data, link, callback=function(res){instructors.get_instructors()}){
  $.ajax({
    method: method,
    data: data,
    url: link,
    success: function(res) {
      students.errors = {};
      callback(res);
    },
    error: function(res) {
      console.log("error");
      students.errors = res.responseJSON;
    }
  })
}

///////////////////////////////////////////////////////
//// A component to create a camp instructor list item
///////////////////////////////////////////////////////
Vue.component('student-row', {

  template: `
    <li>
      <a v-on:click="remove_record(student)" class="remove">x&nbsp;&nbsp;</a>
      {{ student.last_name }},&nbsp;{{ student.first_name }}
    </li>
  `,

  props: {
    instructor: Object
  },

  data: function () {
    return {
      camp_id: 0
    }
  },

  created() {
    this.camp_id = $('#camp_id').val();
  },

  methods: {
    remove_record: function(instructor){
      run_ajax('DELETE', {student: student}, '/camps/'.concat(this.camp_id, '/students/',student['id'],'.json'));
    }
  }
});


/////////////////////////////////////////////
//// A component for adding a new instructor
/////////////////////////////////////////////
var new_form = Vue.component('new-student-form', {
  template: '#camp-student-form-template',

  mounted() {
    // need to reconnect the materialize select javascript 
    $('#camp_instructor_instructor_id').material_select()
  },

  data: function () {
    return {
        camp_id: 0,
        instructor_id: 0,
        errors: {}
    }
  },

  methods: {
    submitForm: function (x) {
      new_post = {
        camp_id: this.camp_id,
        instructor_id: this.instructor_id
      }
      run_ajax('POST', {instructor: new_post}, '/camp_instructors.json')
      this.switch_modal()
    }
  },
})



//////////////////////////////////////////
////***  The Vue instance itself  ***////
/////////////////////////////////////////
var instructors = new Vue({

  el: '#assignments',

  data: {
    camp_id: 0,
    instructors: [],
    modal_open: false,
    errors: {}
  },

  created() {
    this.camp_id = $('#camp_id').val();
  },

  methods: {
    switch_modal: function(event){
      this.modal_open = !(this.modal_open);
    },

    get_instructors: function(){
      run_ajax('GET', {}, '/camps/'.concat(this.camp_id, '/instructors.json'), function(res){instructors.instructors = res});
    }
  },

  mounted: function(){
    this.get_instructors();
  }
});