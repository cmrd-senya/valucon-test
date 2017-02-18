valucon = angular.module('valucon',[
  'templates',
  'ngRoute',
  'controllers',
  "ngFlash"
])

valucon.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
      )
      .when('/feedbacks/new',
        templateUrl: "feedbacks/new.html"
        controller: 'FeedbacksController'
      )
])

valucon.config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]