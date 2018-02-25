/* global Vue, VueRouter, axios */

// Contacts components
var ContactsIndexPage = {
  template: "#contacts-index-page",
  data: function() {
    return {
      erros: [],
      contacts: []
    };
  },
  created: function() {
    axios.get("/contacts").then(
      function(contactsResponse) {
        this.contacts = contactsResponse.data;
      }.bind(this)
    );
  },
  methods: {},
  computed: {}
};

// Authorization components

var SingupPage = {
  template: "#signup-page",
  data: function() {
    return {
      email: "",
      password: "",
      passwordConfirmation: "",
      erros: []
    };
  },
  created: function() {},
  methods: {
    submit: function() {
      var parameters = {
        email: this.email,
        password: this.password,
        password_confirmation: this.passwordConfirmation
      };
      axios
        .post("/users", parameters)
        .then(
          function(usersCreateResponse) {
            router.push("/login");
          }.bind(this)
        )
        .catch(
          function(error) {
            this.errors = error.usersCreateResponse.data.errors;
          }.bind(this)
        );
    }
  },
  computed: {}
};

var LoginPage = {
  template: "#login-page",
  data: function() {
    return {
      email: "",
      password: "",
      errors: []
    };
  },
  methods: {
    submit: function() {
      var params = {
        auth: { email: this.email, password: this.password }
      };
      axios
        .post("/user_token", params)
        .then(function(response) {
          axios.defaults.headers.common["Authorization"] =
            "Bearer " + response.data.jwt;
          localStorage.setItem("jwt", response.data.jwt);
          router.push("/");
        })
        .catch(
          function(error) {
            this.errors = ["Invalid email or password."];
            this.email = "";
            this.password = "";
          }.bind(this)
        );
    }
  }
};

var LogoutPage = {
  created: function() {
    axios.defaults.headers.common["Authorization"] = undefined;
    localStorage.removeItem("jwt");
    router.push("/");
  }
};

var router = new VueRouter({
  routes: [
    // app
    { path: "/", component: ContactsIndexPage },
    { path: "/contacts", component: ContactsIndexPage },
    // user
    { path: "/signup", component: SingupPage },
    { path: "/login", component: LoginPage },
    { path: "/logout", component: LogoutPage }
  ],
  scrollBehavior: function(to, from, savedPosition) {
    return { x: 0, y: 0 };
  }
});

var app = new Vue({
  el: "#vue-app",
  router: router,
  created: function() {
    var jwt = localStorage.getItem("jwt");
    if (jwt) {
      axios.defaults.headers.common["Authorization"] = jwt;
    }
  }
});
