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

        // SQL query to fetch caretaker information with date filter
        $sql = "SELECT user_id, date, total_score, A, B, C, D, E FROM questionarie_scorecard WHERE user_id = ? AND date = ?";

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

// Convert the response array to JSON and echo it
header('Content-Type: application/json');
echo json_encode($response);
?>
