<?php
// Include the database connection configuration
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

$response = array();

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $uploadDirectory = "uploads/";

    // Check if the 'video' key is set in the $_FILES array
    if (isset($_FILES['video']) && $_FILES['video']['error'] === UPLOAD_ERR_OK) {
        $videoFileName = basename($_FILES['video']['name']);
        $videoFilePath = $uploadDirectory . $videoFileName;

        // Ensure upload directory exists
        if (!is_dir($uploadDirectory)) {
            mkdir($uploadDirectory, 0777, true);
        }

        // Move uploaded file to the upload directory
        if (move_uploaded_file($_FILES['video']['tmp_name'], $videoFilePath)) {
            $description = $_POST['description'];
            $subtopic_id = $_POST['subtopic_id'];

            // Fetch topic details from the topics table
            $topicQuery = $conn->prepare("SELECT topic_id, topic_name FROM topics WHERE topic_id = ?");
            $topic_id = $_POST['topic_id']; // Assuming topic_id is sent via POST
            $topicQuery->bind_param("s", $topic_id);
            $topicQuery->execute();
            $topicResult = $topicQuery->get_result();

            if ($topicResult->num_rows > 0) {
                $topicRow = $topicResult->fetch_assoc();
                $topic_name = $topicRow['topic_name'];

                // Insert data into subtopics table
                $insertQuery = $conn->prepare(
                    "INSERT INTO subtopics (video, description, subtopic_id, subtopic_name, topic_id, topic_name) 
                     VALUES (?, ?, ?, ?, ?, ?)"
                );
                $subtopic_name = $_POST['subtopic_name']; // Assuming subtopic_name is sent via POST
                $insertQuery->bind_param("ssssss", $videoFilePath, $description, $subtopic_id, $subtopic_name, $topic_id, $topic_name);

                if ($insertQuery->execute()) {
                    $response['success'] = true;
                    $response['message'] = "Data inserted successfully.";
                } else {
                    $response['success'] = false;
                    $response['message'] = "Error: " . $conn->error;
                }

                $insertQuery->close();
            } else {
                $response['success'] = false;
                $response['message'] = "Error: Topic not found.";
            }

            $topicQuery->close();
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
