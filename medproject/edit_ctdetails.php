<?php
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    $user_id = $_POST['user_id'];
    $Name = $_POST['Name'];
    $phone_no = $_POST['phone_no'];
    $p_Name = $_POST['p_Name'];
    $Relationship = $_POST['Relationship'];
    $Diagnosis = $_POST['Diagnosis'];

    // Check if the user_id already exists in doctor_profile
    $check_sql = "SELECT user_id FROM Add_Caretakers WHERE user_id = '$user_id'";
    $check_result = $conn->query($check_sql);

    if ($check_result->num_rows > 0) {
        // User exists, update the data
        $update_sql = "UPDATE Add_Caretakers SET Name='$Name', phone_no='$phone_no', p_Name='$p_Name', Relationship='$Relationship', Diagnosis='$Diagnosis' WHERE user_id='$user_id'";

        if ($conn->query($update_sql) === TRUE) {
            // Successful update
            $response = array('status' => true, 'message' => 'User data updated successfully.');
            echo json_encode($response);
        } else {
            // Error in database update
            $response = array('status' => false, 'message' => 'Error: ' . $conn->error);
            echo json_encode($response);
        }
    } else {
        // User does not exist
        $response = array('status' => false, 'message' => 'User does not exist.');
        echo json_encode($response);
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => false, 'message' => 'Invalid request method.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
