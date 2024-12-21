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

    // Get input data from the application
    $user_id = $_POST['user_id'];

    // Check if the user_id exists in the Doctor table
    $check_sql = "SELECT user_id FROM Doctor WHERE user_id = '$user_id'";
    $check_result = $conn->query($check_sql);

    if ($check_result->num_rows > 0) {
        // Process image uploads
        $imagePaths = array(
            uploadImages("image1"),
            uploadImages("image2"),
            uploadImages("image3"),
            uploadImages("image4"),
            uploadImages("image5"),
            uploadImages("image6")
        );

        // Fix the SQL query
        $sql = "INSERT INTO motivation_images (user_id, image1, image2, image3, image4, image5, image6) 
                VALUES ('$user_id', 
                '" . implode(",", $imagePaths[0]) . "', 
                '" . implode(",", $imagePaths[1]) . "', 
                '" . implode(",", $imagePaths[2]) . "', 
                '" . implode(",", $imagePaths[3]) . "', 
                '" . implode(",", $imagePaths[4]) . "', 
                '" . implode(",", $imagePaths[5]) . "')";

        if ($conn->query($sql) === TRUE) {
            // Successful insertion
            $response = array('status' => 'success', 'message' => 'Images uploaded successfully.');
            echo json_encode($response);
        } else {
            // Error in database insertion
            $response = array('status' => 'error', 'message' => 'Error: ' . $conn->error);
            echo json_encode($response);
        }
    } else {
        // User does not exist in the Doctor table
        $response = array('status' => 'error', 'message' => 'User does not exist.');
        echo json_encode($response);
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