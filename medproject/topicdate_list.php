<?php
// Include the database connection configuration
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

$response = array();

if ($_SERVER["REQUEST_METHOD"] == "GET") {
    $table_name = 'topic_answer';
    $user_id = $_GET['user_id'];

    $sql = "SELECT subtopic_id, subtopic_name, user_id, date FROM $table_name WHERE user_id = ?";
    $stmt = $conn->prepare($sql);

    if ($stmt) {
        $stmt->bind_param("s", $user_id);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $rows = $result->fetch_all(MYSQLI_ASSOC);

            // Debug statement to check fetched rows
            error_log("Fetched rows: " . print_r($rows, true));

            $response['success'] = true;
            $response['data'] = $rows;
        } else {
            $response['success'] = false;
            $response['message'] = "No data found in the '$table_name' table for user_id: $user_id";
        }
    } else {
        $response['success'] = false;
        $response['message'] = "Error in preparing the SQL query: " . $conn->error;
    }
} else {
    $response['success'] = false;
    $response['message'] = "Invalid request method.";
}

$conn->close();

header('Content-Type: application/json');
echo json_encode($response);
?>
