<?php
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Initialize response array
$response = array();

// Check if the form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    
    // Retrieve data from the form
    $user_id = isset($_POST["user_id"]) ? $_POST["user_id"] : "";
    $date = date('Y-m-d');
    $suggestion = isset($_POST["suggestion"]) ? $_POST["suggestion"] : "";

    // Check if the user_id, date, and suggestion are not empty
    if (!empty($user_id) && !empty($date) && !empty($suggestion)) {

        // Check if the user_id exists in the doctor table
        $check_user_query = "SELECT * FROM Add_Caretakers WHERE user_id = ?";
        $check_user_stmt = $conn->prepare($check_user_query);
        $check_user_stmt->bind_param("s", $user_id);
        $check_user_stmt->execute();
        $check_user_result = $check_user_stmt->get_result();

        if ($check_user_result->num_rows > 0) {
            // User_id exists in the doctor table, proceed with inserting suggestion
            $insert_query = "INSERT INTO suggestions (user_id, date, suggestion) VALUES (?, ?, ?)";
            $insert_stmt = $conn->prepare($insert_query);
            $insert_stmt->bind_param("sss", $user_id, $date, $suggestion);

            // Execute the statement
            if ($insert_stmt->execute()) {
                $response["success"] = true;
                $response["message"] = "Suggestion added successfully";
            } else {
                $response["success"] = false;
                $response["message"] = "Error: " . $insert_stmt->error;
            }

            // Close the statement
            $insert_stmt->close();
        } else {
            // User_id doesn't exist in the doctor table
            $response["success"] = false;
            $response["message"] = "Enter a valid user_id";
        }

        // Close the statement for checking user_id
        $check_user_stmt->close();
    } else {
        // One or more fields are empty
        $response["success"] = false;
        $response["message"] = "All fields are required";
    }
}

// Close the database connection
$conn->close();

// Output the response as JSON
header('Content-Type: application/json');
echo json_encode($response);
?>
