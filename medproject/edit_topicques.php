<?php
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Get the JSON data from the request body
$json_data = file_get_contents('php://input');
$data = json_decode($json_data, true);

// Check if the request is a POST request and if JSON data was successfully parsed
if ($_SERVER['REQUEST_METHOD'] === 'POST' && $data !== null) {
    // Extract input data from the decoded JSON
    $subtopic_id = $data['subtopic_id'];
    $question_id = $data['question_id'];
    $question = $data['question'];
    $options = $data['options'];

    // Check if the combination of subtopic_id and question_id already exists in video_questions
    $check_sql = "SELECT question_id FROM video_questions WHERE subtopic_id = '$subtopic_id' AND question_id = '$question_id'";
    $check_result = $conn->query($check_sql);

    if ($check_result->num_rows > 0) {
        // Record exists, update the data
        $update_sql = "UPDATE video_questions 
                       SET question ='$question', 
                           option_a='$options[0]', 
                           option_b='$options[1]', 
                           option_c='$options[2]', 
                           option_d='$options[3]' 
                       WHERE subtopic_id='$subtopic_id' AND question_id='$question_id'";

        if ($conn->query($update_sql) === TRUE) {
            // Successful update
            $response = array('status' => true, 'message' => 'Question data updated successfully.');
            echo json_encode($response);
        } else {
            // Error in database update
            $response = array('status' => false, 'message' => 'Error: ' . $conn->error);
            echo json_encode($response);
        }
    } else {
        // Record does not exist
        $response = array('status' => false, 'message' => 'Record does not exist.');
        echo json_encode($response);
    }
} else {
    // Handle non-POST requests or invalid JSON data
    $response = array('status' => false, 'message' => 'Invalid request or JSON data.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
