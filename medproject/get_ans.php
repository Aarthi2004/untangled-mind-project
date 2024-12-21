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
        // Get the user_id and date parameters from the request
        $userId = isset($_GET['user_id']) ? $_GET['user_id'] : null;
        $selectedDate = isset($_GET['date']) ? $_GET['date'] : null;

        if ($userId !== null && $selectedDate !== null) {
            // SQL query to fetch answers for a specific user_id and date
            $sql = "SELECT a.user_id, a.date, a.question_id, a.user_answer, q.question_text 
                    FROM answers AS a
                    INNER JOIN qns AS q ON a.question_id = q.question_id
                    WHERE a.user_id = ? AND a.date = ?";

            // Prepare the SQL query
            $stmt = $conn->prepare($sql);

            // Bind parameters
            $stmt->bind_param("ss", $userId, $selectedDate);

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
                $response['message'] = "0 results for the specified user and date";
            }
        } else {
            $response['status'] = false;
            $response['message'] = "Both user_id and date are required parameters.";
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
    // Close the statement and database connection
    if (isset($stmt)) {
        $stmt->close();
    }
    $conn->close();
}

// Convert the response array to JSON and echo it
header('Content-Type: application/json');
echo json_encode($response);
?>
