<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $targetDirectory = "uploads/";
    function uploadImages($fieldName) {
        global $targetDirectory;
        $result = [];

        // Check if the field name exists and if it's an array
        if (isset($_FILES[$fieldName]) && is_array($_FILES[$fieldName]["name"])) {
            foreach ($_FILES[$fieldName]["name"] as $key => $value) {
                $targetFile = $targetDirectory . basename($_FILES[$fieldName]["name"][$key]);
                if (move_uploaded_file($_FILES[$fieldName]["tmp_name"][$key], $targetFile)) {
                    $result[] = $targetFile;
                } else {
                    $result[] = null;
                }
            }
        } elseif (isset($_FILES[$fieldName])) {
            // If there's only one file, treat it as an array
            $targetFile = $targetDirectory . basename($_FILES[$fieldName]["name"]);
            if (move_uploaded_file($_FILES[$fieldName]["tmp_name"], $targetFile)) {
                $result[] = $targetFile;
            } else {
                $result[] = null;
            }
        }

        return $result;
    }
    $imagePath1 = isset($_FILES["Caretaker_image"]) ? uploadImages("Caretaker_image") : [];
    // Get input data from the application
    $Doctor_id = $_POST['id'];
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
   

    // Check if the user_id already exists in Add_Ct
    $check_sql = "SELECT user_id FROM add_ct WHERE user_id = '$username'";
    $check_result = $conn->query($check_sql);

    if ($check_result->num_rows > 0) {
        // User already exists
        $response = array('status' => 'error', 'message' => 'User already exists.');
        echo json_encode($response);
    } else {
        // Fix the SQL query here
        $sql = "INSERT INTO add_ct (user_id, id, Name, phone_no, Age, password, gender, Relationship, p_Name, p_Age, p_Gender, Diagnosis,Caretaker_image) 
        VALUES ('$username','$Doctor_id','$name','$mobilenumber', '$age','$password','$gender','$relationship','$p_name','$p_age', '$p_gender','$diagnosis','" . implode(",", $imagePath1) . "')";
        if ($conn->query($sql) === TRUE) {
            // Successful insertion
            $response = array('status' => 'success', 'message' => 'User registration successful.');

            // Insert user_id and password into Caretaker_login table
            

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
