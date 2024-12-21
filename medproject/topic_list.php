<?php
// Include the database connection configuration
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

$response = array();

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    // Assuming your table is named 'topics'
    $topics = 'topics';

    // Query to retrieve topic name and image
    $sql = "SELECT topic_id,topic_name FROM $topics";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // Fetch all rows
        $rows = $result->fetch_all(MYSQLI_ASSOC);

        $response['success'] = true;
        $response['data'] = $rows;
    } else {
        $response['success'] = false;
        $response['message'] = "No data found in the 'topics' table.";
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
