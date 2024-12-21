<?php
// Set error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Include the database connection file
require_once('db.php');

// Create an associative array to hold the API response
$response = array();

try {
    // Check if the request method is GET
    if ($_SERVER["REQUEST_METHOD"] === "GET") {
        // Check if user_id parameter is provided
        $userId = isset($_GET['user_id']) ? $_GET['user_id'] : null;
        
        // SQL query to fetch caretaker information
        $sql = "SELECT user_id, date FROM questionarie_scorecard WHERE user_id = ?";

        // Prepare the SQL query
        $stmt = $conn->prepare($sql);
        
        // Bind parameters
        $stmt->bind_param("i", $userId);

        // Execute the query
        if ($stmt->execute()) {
            // Get the result set from the prepared statement
            $result = $stmt->get_result();

            // Fetch all rows as an associative array
            $data = $result->fetch_all(MYSQLI_ASSOC);

            if (count($data) > 0) {
                $response['status'] = true;
                $response['data'] = $data;
            } else {
                $response['status'] = false;
                $response['message'] = "No data found for user_id: $userId";
            }
        } else {
            throw new Exception("Error executing the query");
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
    // Close the statement
    if (isset($stmt)) {
        $stmt->close();
    }
    
    // Close the database connection
    if (isset($conn)) {
        $conn->close();
    }
}

// Convert the response array to JSON and echo it
header('Content-Type: application/json');
echo json_encode($response);
?>
