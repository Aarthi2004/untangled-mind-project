<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Retrieve data from the form
    $userId = $_POST["user_id"];
    $dayNumber = 1; // Default to day 1
    
    // Ensure that $_POST["user_answer"] is an array
    $user_answers = is_array($_POST["user_answer"]) ? $_POST["user_answer"] : array($_POST["user_answer"]);

    // Retrieve the maximum day for the given user
    $dayQuery = "SELECT MAX(DATE(day)) as max_day FROM user_responses WHERE user_id = '$userId'";
    $dayResult = $conn->query($dayQuery);
    $dayRow = $dayResult->fetch_assoc();

    if ($dayRow['max_day'] !== null) {
        // If there is existing data, increment the day
        $dayNumber = (int) $dayRow['max_day'] + 1;
    }

    $successCount = 0;

    foreach ($user_answers as $index => $user_answer) {
        $ques_id = $index + 1; // Assuming questions have sequential IDs starting from 1
        $check_sql = "INSERT INTO user_responses (user_answer, day, user_id, date) VALUES ('$user_answer', '$dayNumber', '$userId', CURRENT_DATE)";
        $check_result = $conn->query($check_sql);

        if ($check_result === TRUE) {
            $successCount++;
        }
    }

    // Debugging statements
    error_log("Success Count: $successCount");
    error_log("User Answers Count: " . count($user_answers));

    if ($successCount == count($user_answers)) {
        $response["success"] = true;
        $response["message"] = "Data inserted successfully";
    } else {
        $response["success"] = false;
        $response["message"] = "Error inserting answers";
    }

    // Output the response
    echo json_encode($response);
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('success' => false, 'message' => 'Invalid request method.');
    header('Content-Type: application/json; charset=UTF-8');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
