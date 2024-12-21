<?php
error_reporting(0);
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);


// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if 'user_id' is set
    if (isset($_POST['user_id'])) {
        // Get the Userid from the POST data
        $user_id = trim($_POST['user_id']);

        // SQL query to retrieve all entries for a given Userid
        $query = "SELECT user_id, Name, Diagnosis,Caretaker_image FROM Add_Caretakers WHERE user_id = ?";
        $stmt = $conn->prepare($query);

        // Check if the statement was successfully prepared
        if ($stmt) {
            // Bind parameters and execute the query
            $stmt->bind_param('s', $user_id); // Assuming 's' is appropriate for the datatype of Userid
            $stmt->execute();

            // Get the result set
            $result = $stmt->get_result();

            if ($result->num_rows > 0) {
                // Fetch all rows as an associative array
                $search = array(); // Change the variable name from $viewadvices to $search
                while ($row = $result->fetch_assoc()) {
                    $search[] = $row; // Change the variable name from $viewadvices to $search
                }

                // Return all entries for the given Userid as JSON with proper Content-Type header
                header('Content-Type: application/json');
                echo json_encode(array('status' => true, 'search' => $search)); // Change the key from 'viewadvices' to 'search'
            } else {
                // No patient found with the provided Userid
                header('Content-Type: application/json');
                echo json_encode(array('status' => false, 'message' => 'No advice found for the provided Userid.'));
            }
        } else {
            // Handle statement preparation error
            header('Content-Type: application/json');
            echo json_encode(array('status' => false, 'message' => 'Error preparing the SQL statement.'));
        }

        // Close the statement
        $stmt->close();
    } else {
        // 'user_id' not provided
        header('Content-Type: application/json');
        echo json_encode(array('status' => false, 'message' => 'Please provide a user_id.'));
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    header('Content-Type: application/json');
    echo json_encode(array('status' => false, 'message' => 'Invalid request method.'));
}

// Close the database connection
$conn->close();
?>
