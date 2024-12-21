<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    $username = $_POST['user_id'];
    $name = $_POST['Name'];
    $mobilenumber = $_POST['phone_no'];
    $email = $_POST['email_id'];
    $password = $_POST['password'];
    $designation = $_POST['designation'];
    $institution = $_POST['institution'];

    // Prepare the SQL statement with parameterized queries to prevent SQL injection
    $check_stmt = $conn->prepare("SELECT email_id FROM Doctor WHERE email_id = ?");
    $check_stmt->bind_param("s", $email);
    $check_stmt->execute();
    $check_result = $check_stmt->get_result();

    if ($check_result->num_rows > 0) {
        // User already exists
        $response = array('status' => 'error', 'message' => 'User already exists.');
        echo json_encode($response);
    } else {
        // Prepare the SQL statement for insertion
        $insert_stmt = $conn->prepare("INSERT INTO Doctor (user_id, Name, phone_no, email_id, password, designation, institution) 
                                       VALUES (?, ?, ?, ?, ?, ?, ?)");
        $insert_stmt->bind_param("sssssss", $username, $name, $mobilenumber, $email, $password, $designation, $institution);

        if ($insert_stmt->execute()) {
            // Successful insertion
            $response = array('status' => 'success', 'message' => 'User registration successful.');
            echo json_encode($response);
        } else {
            // Error in database insertion
            $response = array('status' => 'error', 'message' => 'Error: ' . $conn->error);
            echo json_encode($response);
        }
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => 'error', 'message' => 'Invalid request method.');
    header('Content-Type: application/json; charset=UTF-8');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
