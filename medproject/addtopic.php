<?php
// Include the database connection configuration
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

$response = array();

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    if (isset($_POST['topic_id']) && isset($_POST['topic_name']) && isset($_POST['subtopic_name']) && isset($_POST['subtopic_id']) && isset($_FILES['video']) && $_FILES['video']['error'] === UPLOAD_ERR_OK) {

        $topic_id = $_POST['topic_id'];
        $topic_name = $_POST['topic_name'];
        $subtopic_name = $_POST['subtopic_name'];
        $subtopic_id = $_POST['subtopic_id']; // Use the provided subtopic_id
        $uploadDirectory = "uploads/";
        $videoFileName = $_FILES['video']['name'];
        $videoFilePath = $uploadDirectory . $videoFileName;

        // Check if the file was successfully uploaded
        if (move_uploaded_file($_FILES['video']['tmp_name'], $videoFilePath)) {
            $description = isset($_POST['description']) ? $_POST['description'] : ''; // Handle case when description is not set

            // Check if the topic exists
            $topicCheckSql = $conn->prepare("SELECT topic_id FROM topics WHERE topic_id = ?");
            $topicCheckSql->bind_param("s", $topic_id);
            $topicCheckSql->execute();
            $topicCheckResult = $topicCheckSql->get_result();

            if ($topicCheckResult->num_rows > 0) {
                // Topic exists, so we don't insert it again
                // Insert data into subtopics table
                $subtopicSql = $conn->prepare("INSERT INTO subtopics (topic_id, topic_name, subtopic_id, subtopic_name, video, description) VALUES (?, ?, ?, ?, ?, ?)");
                $subtopicSql->bind_param("ssssss", $topic_id, $topic_name, $subtopic_id, $subtopic_name, $videoFilePath, $description);

                if ($subtopicSql->execute()) {
                    $response['success'] = true;
                    $response['message'] = "Data updated successfully";
                } else {
                    $response['success'] = false;
                    $response['message'] = "Error: " . $conn->error;
                }
            } else {
                // Topic doesn't exist, so we insert it along with the subtopic
                $topicSql = $conn->prepare("INSERT INTO topics (topic_id, topic_name) VALUES (?, ?)");
                $topicSql->bind_param("ss", $topic_id, $topic_name);

                if ($topicSql->execute()) {
                    // Insert data into subtopics table
                    $subtopicSql = $conn->prepare("INSERT INTO subtopics (topic_id, topic_name, subtopic_id, subtopic_name, video, description) VALUES (?, ?, ?, ?, ?, ?)");
                    $subtopicSql->bind_param("ssssss", $topic_id, $topic_name, $subtopic_id, $subtopic_name, $videoFilePath, $description);

                    if ($subtopicSql->execute()) {
                        $response['success'] = true;
                        $response['message'] = "Data updated successfully";
                    } else {
                        $response['success'] = false;
                        $response['message'] = "Error: " . $conn->error;
                    }
                } else {
                    $response['success'] = false;
                    $response['message'] = "Error: " . $conn->error;
                }
            }
        } else {
            $response['success'] = false;
            $response['message'] = "Error: Unable to move uploaded file.";
        }
    } else {
        $response['success'] = false;
        $response['message'] = "Error: Required fields are missing or file upload error.";
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
