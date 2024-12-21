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
    if ($_SERVER["REQUEST_METHOD"] == "GET") {
        // Check if the 'search' parameter is set
        if (isset($_GET['search'])) {
            // Use htmlspecialchars to prevent potential XSS attacks
            $searchTerm = htmlspecialchars($_GET['search']);

            // SQL query to fetch suggestions matching the search term
            $sql = "SELECT user_id, Name, Age,doctorimage FROM Doctor WHERE user_id LIKE ? OR Name LIKE ? OR Age LIKE ?";

            // Prepare the SQL query
            $stmt = $conn->prepare($sql);

            if (!$stmt) {
                throw new Exception("Error in preparing SQL statement: " . $conn->error);
            }

            // Bind the parameter
            $searchPattern = "%$searchTerm%";
            $stmt->bind_param("sss", $searchPattern, $searchPattern, $searchPattern);

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
                $response['message'] = "No suggestions found for the specified search term";
            }
        } else {
            $response['status'] = false;
            $response['message'] = "Missing 'search' parameter in the request";
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
