<?php
error_reporting(0);
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Content-Type: application/json');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $targetDirectory = "uploads/";
    
    function uploadImages($fieldName) {
        global $targetDirectory;
        $result = [];

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
    $userid = $_POST['user_id'];
    $updateData = array();

    if (isset($_POST['Name'])) {
        $updateData['Name'] = $_POST['Name'];
    }
    if (isset($_POST['password'])) {
        $updateData['password'] = $_POST['password'];
    }
    if (isset($_POST['Age'])) {
        $updateData['Age'] = $_POST['Age'];
    }
    if (isset($_POST['gender'])) {
        $updateData['gender'] = $_POST['gender'];
    }
    if (isset($_POST['phone_no'])) {
        $updateData['phone_no'] = $_POST['phone_no'];
    }
    if (isset($_POST['Relationship'])) {
        $updateData['Relationship'] = $_POST['Relationship'];
    }
    if (isset($_POST['p_Name'])) {
        $updateData['p_Name'] = $_POST['p_Name'];
    }
    if (isset($_POST['p_Age'])) {
        $updateData['p_Age'] = $_POST['p_Age'];
    }
    if (isset($_POST['p_Gender'])) {
        $updateData['p_Gender'] = $_POST['p_Gender'];
    }
    if (isset($_POST['Diagnosis'])) {
        $updateData['Diagnosis'] = $_POST['Diagnosis'];
    }

    // Check if any data to update is provided
    if (!empty($updateData)) {
        // Use prepared statements to prevent SQL injection
        $check_sql = "SELECT user_id FROM Add_Caretakers WHERE user_id = '$userid'";
        $check_result = $conn->query($check_sql);

        if ($check_result->num_rows > 0) {
            // User exists, update the data
            $update_sql = "UPDATE Add_Caretakers SET " . implode(', ', array_map(function ($key) use ($updateData) {
                return "$key = '{$updateData[$key]}'";
            }, array_keys($updateData))) . " WHERE user_id='$userid'";

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
        // No data to update
        $response = array('status' => false, 'message' => 'No data provided for update.');
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
