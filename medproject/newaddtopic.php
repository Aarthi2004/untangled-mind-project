<?php
require_once('db.php'); // Include database connection
error_reporting(E_ALL);
ini_set('display_errors', 1);

$response = ['success' => false, 'message' => ''];

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $requiredFields = ['topic_id', 'topic_name', 'subtopic_name'];
    $hasFile = isset($_FILES['video']) && $_FILES['video']['error'] === UPLOAD_ERR_OK;

    if ($hasFile && array_reduce($requiredFields, fn($carry, $field) => $carry && isset($_POST[$field]), true)) {
        $topic_id = $_POST['topic_id'];
        $topic_name = $_POST['topic_name'];
        $subtopic_name = $_POST['subtopic_name'];
        $description = $_POST['description'] ?? '';
        $uploadDir = "uploads/"; // Directory for uploaded files
        $videoFile = $_FILES['video'];
        $videoPath = $uploadDir . basename($videoFile['name']);

        // Attempt to upload the video
        if (move_uploaded_file($videoFile['tmp_name'], $videoPath)) {
            // Check if the topic exists
            $topicExists = $conn->query("SELECT topic_id FROM topics WHERE topic_id = '$topic_id'")->num_rows > 0;

            if (!$topicExists) {
                // Insert the topic if it doesn't exist
                $conn->query("INSERT INTO topics (topic_id, topic_name) VALUES ('$topic_id', '$topic_name')");
                $subtopic_id = "$topic_id.1";
            } else {
                // Determine the next subtopic ID
                $result = $conn->query("SELECT MAX(subtopic_id) AS max_id FROM subtopics WHERE topic_id = '$topic_id'");
                $max_id = $result->fetch_assoc()['max_id'];
                $subtopic_id = $max_id ? preg_replace_callback('/(\d+)$/', fn($m) => ++$m[0], $max_id) : "$topic_id.1";
            }

            // Insert the subtopic
            $stmt = $conn->prepare("INSERT INTO subtopics (topic_id, topic_name, subtopic_id, subtopic_name, video, description) VALUES (?, ?, ?, ?, ?, ?)");
            $stmt->bind_param("ssssss", $topic_id, $topic_name, $subtopic_id, $subtopic_name, $videoPath, $description);

            if ($stmt->execute()) {
                $response = ['success' => true, 'message' => 'Data updated successfully'];
            } else {
                $response['message'] = 'Database error: ' . $conn->error;
            }
        } else {
            $response['message'] = 'Error uploading the video';
        }
    } else {
        $response['message'] = 'Required fields missing or file upload error';
    }
} else {
    $response['message'] = 'Invalid request method';
}

$conn->close();
header('Content-Type: application/json');
echo json_encode($response);
?>
