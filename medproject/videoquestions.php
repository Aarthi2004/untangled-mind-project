<?php
error_reporting(0);
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Create an associative array to hold the API response
$response = array();
$stmt = null; // Initialize $stmt here

try {
    // Check if the request method is GET
    if ($_SERVER["REQUEST_METHOD"] === "GET") {
        // Check if the 'subtopic_name' parameter is set
        if (isset($_GET['subtopic_name'])) {
            $subtopic_name = $_GET['subtopic_name'];

            // SQL query to fetch question information along with options for a specific subtopic_name
            $sql = "SELECT question_id, question, option_a, option_b, option_c, option_d FROM video_questions WHERE subtopic_name = ?";

            // Prepare the SQL query
            $stmt = $conn->prepare($sql);

            if (!$stmt) {
                throw new Exception("Error preparing SQL statement: " . $conn->error);
            }

            // Bind the parameter
            $stmt->bind_param("s", $subtopic_name);

            // Execute the query
            $stmt->execute();

            if ($stmt->error) {
                throw new Exception("Error executing SQL statement: " . $stmt->error);
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
                $response['message'] = "No questions found for the specified subtopic_name";
            }
        } else {
            $response['status'] = false;
            $response['message'] = "Missing 'subtopic_name' parameter in the request";
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
    if ($conn) {
        $conn->close();
    }
}

// Convert the response array to JSON and echo it
header('Content-Type: application/json');
echo json_encode($response);
?>
