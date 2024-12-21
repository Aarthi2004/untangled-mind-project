<?php
error_reporting(0);
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Content-Type: application/json');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $targetDirectory = "uploads/";

    function uploadImages($fieldName) {
        global $targetDirectory;
        $result = [];

        if (isset($_FILES[$fieldName]) && is_array($_FILES[$fieldName]["name"])) {
            foreach ($_FILES[$fieldName]["name"] as $key => $value) {
                $targetFile = $targetDirectory . basename($_FILES[$fieldName]["name"][$key]);
                if (move_uploaded_file($_FILES[$fieldName]["tmp_name"][$key], $targetFile)) {
                    $result[] = $targetFile;
                } else {
                    $result[] = null;
                }
            }
        } elseif (isset($_FILES[$fieldName])) {
            $targetFile = $targetDirectory . basename($_FILES[$fieldName]["name"]);
            if (move_uploaded_file($_FILES[$fieldName]["tmp_name"], $targetFile)) {
                $result[] = $targetFile;
            } else {
                $result[] = null;
            }
        }

        return $result;
    }

    // Get input data from the application
    $topicId = $_POST['topic_id'];
    $topicName = $_POST['topic_name'];

    // Check if image is provided
    $uploadedImages = uploadImages('image');

    // Check if any data to update is provided
    if (!empty($topicId) && !empty($topicName)) {
        // Use prepared statements to prevent SQL injection
        $check_sql = "SELECT topic_id FROM topics WHERE topic_id = '$topicId'";
        $check_result = $conn->query($check_sql);

        if ($check_result->num_rows > 0) {
            // Topic exists, update the data in topics table
            $updateTopics_sql = "UPDATE topics SET topic_name = '$topicName'";

            if (!empty($uploadedImages[0])) {
                $updateTopics_sql .= ", image = '{$uploadedImages[0]}'";
            }

            $updateTopics_sql .= " WHERE topic_id='$topicId'";

            if ($conn->query($updateTopics_sql) === TRUE) {
                // Successful update in topics table

                // Update the data in subtopics table
                $updateSubtopics_sql = "UPDATE subtopics SET topic_name = '$topicName' WHERE topic_id='$topicId'";

                if ($conn->query($updateSubtopics_sql) === TRUE) {
                    // Successful update in subtopics table
                    $response = array('status' => true, 'message' => 'Topic data updated successfully.');
                    echo json_encode($response);
                } else {
                    // Error in database update in subtopics table
                    $response = array('status' => false, 'message' => 'Error in subtopics update: ' . $conn->error);
                    echo json_encode($response);
                }
            } else {
                // Error in database update in topics table
                $response = array('status' => false, 'message' => 'Error in topics update: ' . $conn->error);
                echo json_encode($response);
            }
        } else {
            // Topic does not exist
            $response = array('status' => false, 'message' => 'Topic does not exist.');
            echo json_encode($response);
        }
    } else {
        // No data to update
        $response = array('status' => false, 'message' => 'Invalid data provided for update.');
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
