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
        // SQL query to fetch question information along with options
        $sql = "SELECT topic_name, question_1, option_q1_1, option_q1_2, option_q1_3, option_q1_4,  question_2, option_q2_1, option_q2_2, option_q2_3, option_q2_4, question_3, option_q3_1, option_q3_2, option_q3_3, option_q3_4, question_4, option_q4_1, option_q4_2, option_q4_3, option_q4_4 FROM topic_questions";

        // Prepare the SQL query
        $stmt = $conn->prepare($sql);

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
            $response['message'] = "0 results";
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
