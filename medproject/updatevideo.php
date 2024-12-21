<?php
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    $subtopicId = isset($_POST['subtopic_id']) ? $_POST['subtopic_id'] : null;
    $subtopicName = isset($_POST['subtopic_name']) ? $_POST['subtopic_name'] : null; // Fix: Assign value to $subtopicName
    $description = isset($_POST['description']) ? $_POST['description'] : null;
    
    // Check if the subtopic_id already exists in subtopics
    $check_sql = "SELECT subtopic_id FROM subtopics WHERE subtopic_id = '$subtopicId'";
    $check_result = $conn->query($check_sql);
    if ($check_result->num_rows > 0) {
        // Subtopic exists, handle video upload
        if (isset($_FILES['video']) && $_FILES['video']['error'] === UPLOAD_ERR_OK) {
            $uploadDirectory = "uploads/";
            // Construct the file path with subtopic ID as part of the file name
            $videoFileName = $subtopicId . '_' . $subtopicName . '.mp4'; // Corrected variable name
            $videoFilePath = $uploadDirectory . $videoFileName;

            // Move the uploaded file to the specified directory
            if (move_uploaded_file($_FILES['video']['tmp_name'], $videoFilePath)) {
                // Update the database with the file path
                $update_sql = "UPDATE subtopics SET video='$videoFilePath', description='$description' WHERE subtopic_id='$subtopicId'";

                if ($conn->query($update_sql) === TRUE) {
                    // Successful update
                    $response = array('status' => true, 'message' => 'Subtopic data updated successfully.');
                    echo json_encode($response);
                } else {
                    // Error in database update
                    $response = array('status' => false, 'message' => 'Error: ' . $conn->error);
                    echo json_encode($response);
                }
            } else {
                // Handle file upload error
                $response = array('status' => false, 'message' => 'Failed to move uploaded file.');
                echo json_encode($response);
            }
        } else {
            // Handle missing or error in the 'video' key
            $response = array('status' => false, 'message' => 'Missing or invalid video file.');
            echo json_encode($response);
        }
    } else {
        // Subtopic does not exist
        $response = array('status' => false, 'message' => 'Subtopic does not exist.');
        echo json_encode($response);
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => false, 'message' => 'Invalid request method.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
