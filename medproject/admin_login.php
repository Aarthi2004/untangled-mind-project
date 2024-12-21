<?php
error_reporting(0);
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Get user input from POST data
$user_id = $_POST['user_id'];
$password = $_POST['password'];

// Database query
$loginqry = "SELECT * FROM admin WHERE user_id = '$user_id' AND Password = '$password'";
$qry = mysqli_query($conn, $loginqry);

// Prepare the response
$response = [];

if (mysqli_num_rows($qry) > 0) {
    $userArray = [];
    while ($userObj = mysqli_fetch_assoc($qry)) {
        $userArray[] = $userObj;
    }
    $response['status'] = true;
    $response['message'] = "Login Successfully";
    $response['data'] = $userArray;
} else {
    $response['status'] = false;
    $response['message'] = "Login Failed";
}

// Set the HTTP response headers for a JSON response
header('Content-Type: application/json; charset=UTF-8');

// Send the JSON response
echo json_encode($response);
?>
