<?php
// Display all errors for debugging purposes
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require_once('db.php');

// Create an associative array to hold the API response
$response = array();

// Initialize $stmt as null
$stmt = null;

try {
    // Check if the request method is GET
    if ($_SERVER["REQUEST_METHOD"] === "GET") {
        // Check if the 'topic_name' parameter is set
        if (isset($_GET['topic_name'])) {
            // Use htmlspecialchars to prevent potential XSS attacks
            $topic_name = htmlspecialchars($_GET['topic_name']);

            // SQL query to fetch subtopics for a specific topic_name
            $sql = "SELECT topic_name,subtopic_id, subtopic_name FROM subtopics WHERE topic_name = ?";

            // Prepare the SQL query
            $stmt = $conn->prepare($sql);

            if (!$stmt) {
                throw new Exception("Error in preparing SQL statement: " . $conn->error);
            }

            // Bind the parameter
            $stmt->bind_param("s", $topic_name);

            // Execute the query
            if (!$stmt->execute()) {
                throw new Exception("Error in executing SQL statement: " . $stmt->error);
            }

            // Get the result set from the prepared statement
            $result = $stmt->get_result();

            // Fetch all rows as an associative array
            $data = $result->fetch_all(MYSQLI_ASSOC);

            if (count($data) > 0) {
                $response['status'] = true;
                $response['data'] = $data;
            } else {
                $response['status'] = false;
                $response['message'] = "No subtopics found for the specified topic_name";
            }
        } else {
            $response['status'] = false;
            $response['message'] = "Missing 'topic_name' parameter in the request";
        }
    } else {
        $response['status'] = false;
        $response['message'] = "Invalid request method. Only GET requests are allowed.";
    }
} catch (Exception $e) {
    // Handle any exceptions
    $response['status'] = false;
    $response['message'] = "Error: " . $e->getMessage();
} finally {
    // Close the statement if it's not null
    if ($stmt !== null) {
        $stmt->close();
    }

    // Close the database connection
    $conn->close();
}

// Convert the response array to JSON and echo it
header('Content-Type: application/json');
echo json_encode($response);
?>
