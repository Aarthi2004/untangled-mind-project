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
    $age = $_POST['Age'];
    $password = $_POST['password'];
    $gender = $_POST['gender'];
    $relationship = $_POST['Relationship'];
    $p_name = $_POST['p_Name'];
    $p_age = $_POST['p_Age'];
    $p_gender = $_POST['p_Gender'];
    $diagnosis = $_POST['Diagnosis'];
    
    // Initialize the image paths array
    $image_paths = [];

    // Check if caretaker_image is set and not empty
    if (isset($_POST['caretaker_image']) && !empty($_POST['caretaker_image'])) {
        // Convert base64 image to JPEG and save it
        $base64_image = $_POST['caretaker_image'];
        $image_data = base64_decode($base64_image);
        $image_path = 'caretaker_image/' . $username .'.jpg'; // Save with username and unique identifier as filename
        file_put_contents($image_path, $image_data);
        $image_paths[] = $image_path;
    }

    $check_sql = "SELECT user_id FROM Add_Caretakers WHERE user_id = '$username'";
    $check_result = $conn->query($check_sql);

    if ($check_result->num_rows > 0) {
        // User already exists
        $response = array('status' => 'error', 'message' => 'User already exists.');
        echo json_encode($response);
    } else {
        // Insert data into the database
        $sql = "INSERT INTO Add_Caretakers (user_id, Name, phone_no, Age, password, gender, Relationship, p_Name, p_Age, p_Gender, Diagnosis, caretaker_image) 
        VALUES ('$username', '$name', '$mobilenumber', '$age', '$password', '$gender', '$relationship', '$p_name', '$p_age', '$p_gender', '$diagnosis', '" . implode(",", $image_paths) . "')";
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
