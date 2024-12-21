<?php
// Include the database connection configuration
include("db.php");
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

$response = array();

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $uploadDirectory = "uploads/"; 

    // Check if the 'video' key is set in the $_FILES array
    if (isset($_FILES['video']) && $_FILES['video']['error'] === UPLOAD_ERR_OK) {
        $videoFileName = $_FILES['video']['name'];
        $videoFilePath = $uploadDirectory . $videoFileName;

        // Check if the file was successfully uploaded
        if (move_uploaded_file($_FILES['video']['tmp_name'], $videoFilePath)) {
            $description = $_POST['description'];

            $topic_id = $_POST["topic_id"];
            $topic_name = $_POST["topic_name"];

            $question_1 = $_POST["question_1"];
            $option_q1_1 = $_POST["option_q1_1"];
            $option_q1_2 = $_POST["option_q1_2"];
            $option_q1_3 = $_POST["option_q1_3"];
            $option_q1_4 = $_POST["option_q1_4"];

            $question_2 = $_POST["question_2"];
            $option_q2_1 = $_POST["option_q2_1"];
            $option_q2_2 = $_POST["option_q2_2"];
            $option_q2_3 = $_POST["option_q2_3"];
            $option_q2_4 = $_POST["option_q2_4"];
            
            $question_3 = $_POST["question_3"];
            $option_q3_1 = $_POST["option_q3_1"];
            $option_q3_2 = $_POST["option_q3_2"];
            $option_q3_3 = $_POST["option_q3_3"];
            $option_q3_4 = $_POST["option_q3_4"];
            
            $question_4 = $_POST["question_4"];
            $option_q4_1 = $_POST["option_q4_1"];
            $option_q4_2 = $_POST["option_q4_2"];
            $option_q4_3 = $_POST["option_q4_3"];
            $option_q4_4 = $_POST["option_q4_4"];
                        
           

            
$sql = "INSERT INTO topic_questions (video, description, topic_id, topic_name, question_1, option_q1_1, option_q1_2, option_q1_3, option_q1_4, 
question_2, option_q2_1, option_q2_2, option_q2_3, option_q2_4,
question_3, option_q3_1, option_q3_2, option_q3_3, option_q3_4,
question_4, option_q4_1, option_q4_2, option_q4_3, option_q4_4)
VALUES ('$videoFilePath', '$description', '$topic_id', '$topic_name',
'$question_1', '$option_q1_1', '$option_q1_2', '$option_q1_3', '$option_q1_4',
'$question_2', '$option_q2_1', '$option_q2_2', '$option_q2_3', '$option_q2_4',
'$question_3', '$option_q3_1', '$option_q3_2', '$option_q3_3', '$option_q3_4',
'$question_4', '$option_q4_1', '$option_q4_2', '$option_q4_3', '$option_q4_4')";

if ($conn->query($sql) === TRUE) {
$response['success'] = true;
$response['message'] = "Data updated successfully";
} else {
$response['success'] = false;
$response['message'] = "Error: " . $conn->error;
}

// ... (your existing code)

            
            if ($conn->query($sql) === TRUE) {
                $response['success'] = true;
                $response['message'] = "Data updated successfully";
            } else {
                $response['success'] = false;
                $response['message'] = "Error: " . $conn->error;
            }
        } else {
            $response['success'] = false;
            $response['message'] = "Error: Unable to move uploaded file.";
        }
    } else {
        $response['success'] = false;
        $response['message'] = "Error: File upload error or 'video' is not set in the form.";
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
