<?php
require_once('db.php'); // Include your database connection code

// Set up error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate and sanitize input data
    $question_id = isset($_POST['question_id']) ? $_POST['question_id'] : '';
    $Question_text = isset($_POST['question_text']) ? $_POST['question_text'] : '';
    $option_a = isset($_POST['option_a']) ? $_POST['option_a'] : '';
    $option_b = isset($_POST['option_b']) ? $_POST['option_b'] : '';
    $option_c = isset($_POST['option_c']) ? $_POST['option_c'] : '';
    $option_d = isset($_POST['option_d']) ? $_POST['option_d'] : '';
    $option_e = isset($_POST['option_e']) ? $_POST['option_e'] : '';

    // Insert data into the database
    $sql = "INSERT INTO qns (question_id, Question_text, option_a, option_b, option_c, option_d, option_e) 
            VALUES ('$question_id', '$Question_text', '$option_a', '$option_b', '$option_c', '$option_d', '$option_e')";

    if ($conn->query($sql) === TRUE) {
        // Successful insertion
        $response = array('status' => 'success', 'message' => 'Question added successfully.');
        echo json_encode($response);
    } else {
        // Error in database insertion
        $response = array('status' => 'error', 'message' => 'Error: ' . $conn->error);
        echo json_encode($response);
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => 'error', 'message' => 'Invalid request method.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
