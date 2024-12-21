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
    $emailid = $_POST['email_id']; // Assuming you'll use it later
    $mobilenumber = $_POST['phone_no'];
    $password = $_POST['password'];
    $designation = $_POST['designation'];
    $institution = $_POST['institution'];
    $age = $_POST['Age']; // Corrected variable name
    $gender = $_POST['Gender']; // Corrected variable name
    
    $check_sql = "SELECT user_id FROM Doctor WHERE user_id = '$username'";
    $check_result = $conn->query($check_sql);

    if ($check_result->num_rows > 0) {
        // User already exists
        $response = array('status' => 'error', 'message' => 'User already exists.');
        echo json_encode($response);
    } else {
        // Convert base64 image to JPEG and save it
        if (isset($_POST['doctorimage'])) {
            $base64_image = $_POST['doctorimage'];
            $image_data = base64_decode($base64_image);
            $image_path = 'doctor_image/' . $username . '.jpg'; // Save with username as filename
            $image_file = fopen($image_path, 'wb');
            fwrite($image_file, $image_data);
            fclose($image_file);
        } else {
            $image_path = null;
        }

        // Insert data into the database
        $sql = "INSERT INTO Doctor (user_id, Name, email_id, phone_no, Age, password, Gender, designation, institution, doctorimage) 
        VALUES ('$username','$name','$emailid','$mobilenumber','$age','$password','$gender','$designation','$institution','$image_path')"; // Corrected variable name
        if ($conn->query($sql) === TRUE) {
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
