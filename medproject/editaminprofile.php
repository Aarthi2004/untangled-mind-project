<?php
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    $userid = $_POST['user_id'];

    // Check if the user_id already exists in the database
    $check_sql = "SELECT * FROM admin WHERE user_id = '$userid'";
    $check_result = $conn->query($check_sql);

    if ($check_result->num_rows > 0) {
        // User exists
        $existing_data = $check_result->fetch_assoc();

        // Initialize an array to hold update statements
        $update_fields = array();

        // Check if each field is provided and add it to the update_fields array
        if (isset($_POST['Name'])) {
            $update_fields[] = "Name='" . $_POST['Name'] . "'";
        } else {
            $update_fields[] = "Name='" . $existing_data['Name'] . "'";
        }

        if (isset($_POST['password'])) {
            $update_fields[] = "password='" . $_POST['password'] . "'";
        } else {
            $update_fields[] = "password='" . $existing_data['password'] . "'";
        }

        if (isset($_POST['email_id'])) {
            $update_fields[] = "email_id='" . $_POST['email_id'] . "'";
        } else {
            $update_fields[] = "email_id='" . $existing_data['email_id'] . "'";
        }

        if (isset($_POST['designation'])) {
            $update_fields[] = "designation='" . $_POST['designation'] . "'";
        } else {
            $update_fields[] = "designation='" . $existing_data['designation'] . "'";
        }

        if (isset($_POST['phone_no'])) {
            $update_fields[] = "phone_no='" . $_POST['phone_no'] . "'";
        } else {
            $update_fields[] = "phone_no='" . $existing_data['phone_no'] . "'";
        }

        if (isset($_POST['institution'])) {
            $update_fields[] = "institution='" . $_POST['institution'] . "'";
        } else {
            $update_fields[] = "institution='" . $existing_data['institution'] . "'";
        }

        // Construct the UPDATE query
        $update_sql = "UPDATE admin SET " . implode(', ', $update_fields) . " WHERE user_id='$userid'";

        if (!empty($update_fields)) {
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
            // No fields provided for update
            $response = array('status' => false, 'message' => 'No fields provided for update.');
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
