controllers = angular.module('controllers')
controllers.controller("UploadsController", [ '$scope', '$http', 'Upload', '$window', 'Flash'
  ($scope, $http, Upload, $window, Flash)->
    $scope.submit = ->
      if $scope.form.file.$valid and $scope.file
        $scope.upload($scope.file)

    # upload on file select or drop
    $scope.upload = (file) ->
      Upload.upload({
        url: 'photos',
        data: {photo: {image: file}}
      }).then(
        (resp) ->
          $window.location.href = '/#!/photos'
        (resp) ->
          Flash.create('danger', 'Upload failed!', 3000, {}, false);
     )
])