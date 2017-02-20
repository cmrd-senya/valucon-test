valucon = angular.module('valucon',[
  'templates',
  'ngRoute',
  'controllers',
  'ngFileUpload',
  "ngFlash"
])

valucon.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html",
        controller: "UploadsController"
      )
      .when('/photos',
        templateUrl: "photos/index.html",
        controller: 'PhotosController'
      )
      .when('/feedbacks/new',
        templateUrl: "feedbacks/new.html"
        controller: 'FeedbacksController'
      )
])

valucon.config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]

controllers = angular.module('controllers', [])
