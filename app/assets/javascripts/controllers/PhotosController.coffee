controllers = angular.module('controllers')
controllers.controller("PhotosController", [ '$scope', '$http'
  ($scope, $http)->
    $scope.photos = []
    $http.get("/photos").then(
      (response) ->
        $scope.photos = response.data
    )
])