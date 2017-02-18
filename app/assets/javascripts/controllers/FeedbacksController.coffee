controllers = angular.module('controllers',[])
controllers.controller("FeedbacksController", [ '$scope', '$http', 'Flash'
  ($scope, $http, Flash)->
    $scope.newFeedback = ->
      $http.post("feedbacks", {feedbackText: $scope.feedbackText, email: $scope.email}).then(
        ->
          Flash.create('success', 'Feedback submitted!', 3000, {}, false);
          $scope.feedbackText = ""
          $scope.email = ""
          $scope.feedbackForm.$setPristine();
          $scope.feedbackForm.$setUntouched();
        ->
          Flash.create('danger', 'Please fill the form fields properly', 3000, {}, false);
      )
])