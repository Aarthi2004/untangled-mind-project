<?php
error_reporting(0);
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Create an associative array to hold the API response
$response = array();

try {
    // Check if the request method is GET
    if ($_SERVER["REQUEST_METHOD"] === "GET") {
        // Check if the user_id is set in the request
        if (isset($_GET['user_id'])) {
            // Get the user_id from the request
            $user_id = $_GET['user_id'];

            // SQL query to fetch caretaker information based on user_id
            $sql = "SELECT Name FROM Doctor WHERE user_id = ?";

            // Prepare the SQL query
            $stmt = $conn->prepare($sql);

            // Bind the user_id parameter
            $stmt->bind_param("s", $user_id);

            // Execute the query
            $stmt->execute();

            // Get the result set from the prepared statement
            $result = $stmt->get_result();

            // Fetch all rows as an associative array
            $data = $result->fetch_all(MYSQLI_ASSOC);

            if (count($data) > 0) {
                $response['status'] = true;
                $response['data'] = $data;
            } else {
                $response['status'] = false;
                $response['message'] = "0 results for the provided user_id";
            }
        } else {
            $response['status'] = false;
            $response['message'] = "user_id parameter is missing in the request.";
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
    // Close the statement if it's set
    if (isset($stmt)) {
        $stmt->close();
    }
    // Close the database connection
    $conn->close();
}

// Convert the response array to JSON and echo it
header('Content-Type: application/json');
echo json_encode($response);
?>
