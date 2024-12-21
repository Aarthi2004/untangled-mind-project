<?php
// Include the database connection configuration
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

$response = array();

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    // Assuming you have a subtopic_name parameter in the GET request
    // Assuming your table is named 'subtopics'
    $subtopics = 'subtopics';

    // Check if the subtopic_name parameter is set
    if (isset($_GET['subtopic_name'])) {
        $subtopic_name = $_GET['subtopic_name'];

        // Use prepared statements to prevent SQL injection
        $sql = "SELECT subtopic_id, video, description FROM $subtopics WHERE subtopic_name = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $subtopic_name);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            // Fetch the first row (assuming one video per subtopic)
            $row = $result->fetch_assoc();
            $subtopic_id = $row['subtopic_id'];
            $video_url = $row['video'];
            $description = $row['description'];

            $response['success'] = true;
            $response['subtopic_id'] = $subtopic_id;
            $response['video_url'] = $video_url;
            $response['description'] = $description;
        } else {
            $response['success'] = false;
            $response['message'] = "No video found for the given subtopic_name.";
        }

        $stmt->close(); // Close the prepared statement
    } else {
        $response['success'] = false;
        $response['message'] = "Missing subtopic_name parameter.";
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
