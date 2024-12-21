<?php
// Include the database connection configuration
include("db.php");
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

$response = array();

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $topic_id = $_POST["topic_id"];
    $topic_name = $_POST["topic_name"];

    $question_id = $_POST["question_id"];
    $question = $_POST["question"];
    $option_a = $_POST["option_a"];
    $option_b = $_POST["option_b"];
    $option_c = $_POST["option_c"];
    $option_d = $_POST["option_d"];

    $sql = "INSERT INTO video_questions ( topic_id, topic_name, question_id,question, option_a, option_b, option_c, option_d)
    VALUES ( '$topic_id', '$topic_name', '$question_id','$question', '$option_a', '$option_b', '$option_c', '$option_d')";

    if ($conn->query($sql) === TRUE) {
        $response['success'] = true;
        $response['message'] = "Data updated successfully";
    } else {
        $response['success'] = false;
        $response['message'] = "Error: " . $conn->error;
    }
} else {
    $response['success'] = false;
    $response['message'] = "Invalid request method.";
}

// Close the database connection
$conn->close();

// Return the JSON response
header('Content-Type: application/json');
echo json_encode($response);
?>
