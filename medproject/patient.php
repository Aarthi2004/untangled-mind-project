<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Initialize day number
    $sql = "SELECT MAX(day) as max_day FROM user_responses";
    $result = $conn->query($sql);
    $row = $result->fetch_assoc();
    $dayNumber = ($row['max_day'] ?? 0) + 1;

    // Retrieve user_id from session (adjust the session variable name if needed)
    session_start();
    $userId = $_SESSION['user_id'] ?? '';

    // Loop through POST data
    foreach ($_POST as $question => $answer) {
        // Use prepared statement to prevent SQL injection
        $stmt = $conn->prepare("INSERT INTO user_responses (user_answer, day, user_id) 
                                VALUES (?, ?, ?)");
        $stmt->bind_param("sss", $answer, $dayNumber, $userId);

        // Execute the prepared statement
        if ($stmt->execute()) {
            // Successful insertion
            $response = array('status' => 'success', 'message' => 'Data inserted successfully');
        } else {
            // Error in database insertion
            $response = array('status' => 'error', 'message' => 'Error: ' . $stmt->error);
        }

        // Close the prepared statement
        $stmt->close();
    }

    // Output the response
    echo json_encode($response);
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => 'error', 'message' => 'Invalid request method.');
    header('Content-Type: application/json; charset=UTF-8');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
