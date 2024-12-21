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
        // SQL query to fetch question information along with options
        $sql = "SELECT question_id, question_text, option_a, option_b, option_c, option_d, option_e FROM qns";

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
            $response['data'] = array();

            // Iterate through the data and structure the response
            foreach ($data as $row) {
                $options = array(
                    (string)$row['option_a'],
                    (string)$row['option_b'],
                    (string)$row['option_c'],
                    (string)$row['option_d'],
                    (string)$row['option_e'],
                );

                $questionData = array(
                    'question_id' => $row['question_id'],
                    'question_text' => $row['question_text'],
                    'options' => $options,
                );

                $response['data'][] = $questionData;
            }

            // Convert the response array to JSON and echo it with JSON_UNESCAPED_UNICODE to keep Unicode characters as they are
            echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_NUMERIC_CHECK);
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
    // Close the statement and database connection
    $stmt->close();
    $conn->close();
}
?>
